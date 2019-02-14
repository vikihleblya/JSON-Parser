//
//  CategoryProtocols.swift
//  JSONTest
//
//  Created by Victor on 13/02/2019.
//  Copyright © 2019 com.example.LoD. All rights reserved.
//

import UIKit

protocol CategoryViewProtocol: class {
    var presenter: CategoryPresenterProtocol?{get set}
    
    func showCategories(with categories: [Category])
    
    func showError()
}

protocol CategoryPresenterProtocol: class {
    var view: CategoryViewProtocol?{get set}
    var interactor: CategoryInteractorInputProtocol? {get set}
    var wireFrame: CategoryWireframeProtocol? {get set}
    
    func viewDidLoad()
    func showNewScreen(for category: Category)
    
}

protocol CategoryWireframeProtocol: class {
    static func createCategoryModule() -> UIViewController
    
    func presentNewScreen(from view: CategoryViewProtocol, for category: Category)
}

protocol CategoryInteractorInputProtocol: class {
    var presenter: CategoryInteractorOutputProtocol?{get set}
    var dataManager: CategoryDataInputProtocol? {get set}
    var categories: [Category] {get set}
    
    func retrieveCategories()
}

protocol CategoryInteractorOutputProtocol: class {
    func didRetrieveCategories(categories: [Category])
    func onError()
}

protocol CategoryDataInputProtocol: class {
    var fileName:String {get}
    func retrieveCategories() -> [Category]
    func deleteAllData()
    func checkTableIsEmpty() -> Bool
    func insert(id: Int, title: String)
    func createTable()
}

protocol CategoryDataOutputProtocol: class {
    func onCategoriesRetrieved(categories: [Category])
    func onError()
}

protocol CategoryWireFrameProtocol: class {
    static func createCategoryModule() -> UIViewController
}
