import UIKit

final class QRViewController: BaseViewController {

    struct Constants {
        static let designViewSize = CGSize(width: 375, height: 480)
        static let designScreenWidth: CGFloat = 375
        static var viewSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let viewWidth = designViewSize.width * ratio
            let viewHeight = designViewSize.height * ratio
            return CGSize(width: viewWidth, height: viewHeight)
        }()
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var QRImageView: UIImageView!
    @IBOutlet private weak var expiredDateLabel: UILabel!
    @IBOutlet private weak var localizedGuideLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIView!

    // MARK: - Public Variable

    var code: String = ""
    var expiredDate: String = ""
    var used: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(code: code, expiredDate: expiredDate, used: used)
    }

    override func applyLocalization() {
        localizedGuideLabel.text = "Vui lòng xuất trình mã code để sử dụng dịch vụ"
    }
}

// MARK: - Private

private extension QRViewController {
    func setupQR(code: String) {
        let data = code.data(using: .ascii, allowLossyConversion: false)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            if let ciImage = filter.outputImage {
                let qrTransform = CGAffineTransform(scaleX: 240, y: 240)
                let qrCode = ciImage.transformed(by: qrTransform)
                let img = UIImage(ciImage: qrCode)
                QRImageView.image = img
            }
        }
    }

    func convertDataTime(withFormat format: TimeInterval ) -> String {
        let date = Date(timeIntervalSince1970: format / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Public

extension QRViewController {
    func setupUI(code: String, expiredDate: String, used: Bool) {
        setupQR(code: code)
        expiredDateLabel.text = "HSD: " + expiredDate
        backgroundView.isHidden = !used
    }
}
