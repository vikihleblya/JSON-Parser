//
//  CategoryWireframe.swift
//  JSONTest
//
//  Created by Victor on 14/02/2019.
//  Copyright © 2019 com.example.LoD. All rights reserved.
//

import UIKit

class CategoryWireframe: CategoryWireFrameProtocol{
    
    static func createCategoryModule() -> UIViewController {
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "CategoryController")
        if let view = navController.children.first as? CategoryController {
            let presenter: CategoryPresenterProtocol & CategoryInteractorOutputProtocol = CategoryPresenter()
            let interactor: CategoryInteractorInputProtocol & CategoryDataOutputProtocol = CategoryInteractor()
            let dataManager: CategoryDataInputProtocol = CategoryDataManager()
            let wireFrame: CategoryWireFrameProtocol = CategoryWireframe()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame as? CategoryWireframeProtocol
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.dataManager = dataManager
            
            return navController
        }
        return UIViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
