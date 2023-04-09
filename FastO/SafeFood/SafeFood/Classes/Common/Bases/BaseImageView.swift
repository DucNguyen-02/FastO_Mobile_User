import UIKit
import Kingfisher

class BaseImageView: UIImageView {
    var cacheSize: CGSize = CGSize.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cacheSize = self.frame.size
    }
    
    fileprivate func configUI() {
        self.backgroundColor = UIColor.clear
        self.contentMode = .scaleAspectFill
    }
}

extension BaseImageView {
    func setDefaultStyle() {
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
    }
    
    func setCornerDefaultStyle() {
        self.layer.cornerRadius = min(frame.width, frame.height) / 2
        self.layer.borderWidth = 0
        self.clipsToBounds = true
    }
    
    func setImage(with urlString: String, placeholderImage: UIImage?) {
        if urlString.isEmpty {
            setDefaultStyle()
            self.image = placeholderImage
            return
        }
        if let url = URL(string: urlString) {
            kf.setImage(with: url, placeholder: placeholderImage)
        } else {
            setDefaultStyle()
            self.image = placeholderImage
        }
    }
    
    func cancelDownloadTask() {
        kf.cancelDownloadTask()
    }
}
