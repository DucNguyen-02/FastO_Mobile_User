//
//  CreateCommunityPresenter.swift
//  SafeFood
//
//  Created by Zipris on 23/11/2022.
//  
//

import UIKit
import SVProgressHUD

final class CreateCommunityPresenter {
    
    // MARK: - Private Variable

    private let imageFolderType: ImageFolderType = .community
    
    // MARK: - Public Variable
    
    var imageUrls: [String] = []
    var community: DetailCommunityModel?
    weak var view: CreateCommunityViewInput?
}

// MARK: - CreateCommunityViewOutput

extension CreateCommunityPresenter: CreateCommunityViewOutput {
    func onViewDidLoad(_ review: [String: Any], id: Int?, type: ScreenCommunityType) {
        switch type {
        case .new:
            postCreateCommunity(review)
        case .update:
            guard let reviewId = id else { return }
            postUpdateCommunity(id: reviewId, review)
        }
    }
    
    func onUploadImage(images: [UIImage]) {
        uploadImage(images: images)
    }
    
    func onGetDetailCommunity(id: Int) {
        getDetailCommunity(id: id)
    }
}

private extension CreateCommunityPresenter {
    func uploadImage(images: [UIImage]) {
        SVProgressHUD.show()
        UploadImageService.shared.uploadImage(images: images, type: imageFolderType.type) { [weak self] result in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case let .success(images):
                self.imageUrls.append(contentsOf: images)
                self.view?.reloadCollectionViewData()
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func getDetailCommunity(id: Int) {
        CommunityService.shared.getDetailCommunity(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(community):
                self.community = community
                self.view?.reloadData()
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func postCreateCommunity(_ review: [String: Any]){
        CommunityService.shared.postCreateCommunity(review) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.popViewController()
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func postUpdateCommunity(id: Int, _ review: [String: Any]) {
        CommunityService.shared.putUpdateCommunity(id: id, review) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.popViewController()
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
}
