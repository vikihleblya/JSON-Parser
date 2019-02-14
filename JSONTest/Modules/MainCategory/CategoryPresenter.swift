//
//  CategoryPresenter.swift
//  JSONTest
//
//  Created by Victor on 13/02/2019.
//  Copyright © 2019 com.example.LoD. All rights reserved.
//

import UIKit

class CategoryPresenter: CategoryPresenterProtocol{
    var view: CategoryViewProtocol?
    var interactor: CategoryInteractorInputProtocol?
    var wireFrame: CategoryWireframeProtocol?
    
    func viewDidLoad() {
        interactor?.retrieveCategories()
    }
    
    func showNewScreen(for category: Category) {
        print("Do something in that section")
    }
}

extension CategoryPresenter: CategoryInteractorOutputProtocol{
    func didRetrieveCategories(categories: [Category]) {
        view?.showCategories(with: categories)
    }
    
    func onError() {
        view?.showError()
    }
    
    
}
