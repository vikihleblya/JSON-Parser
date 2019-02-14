//
//  CategoryInteractor.swift
//  JSONTest
//
//  Created by Victor on 13/02/2019.
//  Copyright © 2019 com.example.LoD. All rights reserved.
//

import UIKit

class CategoryInteractor: CategoryInteractorInputProtocol{
    var categories: [Category] = []
    var presenter: CategoryInteractorOutputProtocol?
    var dataManager: CategoryDataInputProtocol?
    
    
    
    func retrieveCategories() {
        
        dataManager?.createTable()
        if dataManager?.checkTableIsEmpty() == false{
            self.categories = (dataManager?.retrieveCategories())!
            presenter?.didRetrieveCategories(categories: self.categories)
        }
        else{
            let queue = DispatchQueue.global(qos: .utility)
            queue.sync {
                self.getDataFromJson()
            }
            
        }
    }
    
    
}

extension CategoryInteractor{
    func getDataFromJson(){
        let stringUrl = "https://money.yandex.ru/api/categories-list"
        guard let url = URL(string: stringUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do{
                let categories = try JSONDecoder().decode([Category].self, from: data)
                for item in categories{
                    self.categories.append(item)
                    self.dataManager?.insert(id: item.id ?? 0, title: item.title)
                    self.getCategory(item: item)
                }
            }
            catch let JsonErr{
                print(JsonErr)}}
            .resume()
    }
    
    func getCategory(item: Category) {
        for item in item.subs ?? []{
            self.categories.append(item)
            self.dataManager?.insert(id: item.id ?? 0, title: item.title)
            if (item.subs != nil){
                getCategory(item: item)
            }
        }
        self.presenter?.didRetrieveCategories(categories: self.categories)
    }

}

extension CategoryInteractor: CategoryDataOutputProtocol{
    
    func onCategoriesRetrieved(categories: [Category]) {
        presenter?.didRetrieveCategories(categories: categories)
    }
    
    
    func onError() {
        print("Error on Interactor")
    }

}
