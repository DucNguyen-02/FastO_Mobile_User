//
//  SearchViewController.swift
//  SafeFood
//
//  Created by ADMIN on 20/11/2022.
//  
//

import UIKit
import CoreLocation

final class SearchViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var searchTextField: BaseTextField!
    @IBOutlet private weak var backButton: BaseButton!
    @IBOutlet private weak var beginView: SearchInitialView!
    @IBOutlet private weak var resultView: SearchResultView!
    
    // MARK: - Private Variable
    
    private var locationManager: CLLocationManager?
    private var currentLocation: String = ""
    private var timer: Timer?
    
    // MARK: - Public Variable
    
    var keyword: String?
    weak var keywordSearchDelegate: KeywordSearchDelegate?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - IBAction
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        popViewController(animated: true)
    }
}

// MARK: - Private

private extension SearchViewController {
    func setupUI() {
        getUserLocation()
        setupTextField()
        setupSearch(keyword: keyword)
    }
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }

    func setupTextField() {
        searchTextField.delegate = self

        searchTextField.clearButtonMode = .whileEditing
        if let clearButton = searchTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(R.image.icClose(), for: .normal)
        }
    }
    
    func setupView(isSearch: Bool) {
        beginView.isHidden = isSearch
        resultView.isHidden = !isSearch
    }
    
    func setupSearch(keyword: String?) {
        if keyword?.isEmpty == nil {
            setupView(isSearch: false)
        } else {
            guard let keyword = keyword else { return }
            setupView(isSearch: true)
            searchTextField.text = keyword
            resultView.setupData(keyword: keyword)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyword = textField.text.orEmpty
        let isValidatorSearch = keyword.isEmpty || keyword == " "
        setupView(isSearch: !isValidatorSearch)
        resultView.setupData(keyword: keyword)
        keywordSearchDelegate?.addKeyword(keyword: keyword.cleanUpWhitespaces())
        searchTextField.resignFirstResponder()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        setupView(isSearch: false)
        return true
    }
}

// MARK: - CLLocationManagerDelegate

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            beginView.setupData(latitude, longitude)
            locationManager?.stopUpdatingLocation()
        }
    }
}
