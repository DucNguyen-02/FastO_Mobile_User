//
//  DatePickerViewController.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 8/4/22.
//

import UIKit

final class DatePickerViewController: UIViewController {

    struct Constants {
        static let designViewSize = CGSize(width: 375, height: 325)
        static let designScreenWidth: CGFloat = 375
        static var viewSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let viewWidth = designViewSize.width * ratio
            let viewHeight = designViewSize.height * ratio
            return CGSize(width: viewWidth, height: viewHeight)
        }()
    }

    // MARK: - @IBOutlet
    
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var closeButton: BaseButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var confirmButton: BaseButton!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    // MARK: - Public Variable

    weak var delegate: SignUpDelegate?
}

// MARK: - Lifecycle

extension DatePickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        headerView.roundedCorners(corners: .topLeft, radius: 15)
        backgroundView.roundedCorners(corners: .topRight, radius: 15)
    }
}

// MARK: - Private

private extension DatePickerViewController {
    func setupDatePicker() {
        datePicker.date = Date()
    }
}

// MARK: - Action

extension DatePickerViewController {
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func confirmAction(_ sender: Any) {
        delegate?.chooseDate(date: datePicker.date)
        dismiss(animated: true)
    }
}
