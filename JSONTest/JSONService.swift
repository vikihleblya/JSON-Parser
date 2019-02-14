//
//  JSONService.swift
//  JSONTest
//
//  Created by Victor on 12/02/2019.
//  Copyright © 2019 com.example.LoD. All rights reserved.
//

import Foundation

class JSONService{
    fileprivate var categories = [Category]()
    let db = Database()
    
    func getDataFromJson(){
        let stringUrl = "https://money.yandex.ru/api/categories-list"
        guard let url = URL(string: stringUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do{
                let categories = try JSONDecoder().decode([Category].self, from: data)
                for item in categories{
                    self.categories.append(item)
                    self.db.insert(id: item.id ?? 0, title: item.title)
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
            self.db.insert(id: item.id ?? 0, title: item.title)
            if (item.subs != nil){
                getCategory(item: item)
            }
        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }

}
