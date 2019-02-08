import UIKit

class ViewController: UITableViewController {

    fileprivate var articles = [MainCategory]()
    fileprivate var countOfItems: Int = 0
    
    struct MainCategory: Decodable{
        let title: String
        let subs: [Category]
    }
    
    struct Category: Decodable {
        let id: Int
        let title: String
        let subs: [Category]?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articles.removeAll()
        
        let stringUrl = "https://money.yandex.ru/api/categories-list"
        guard let url = URL(string: stringUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do{
                let categories = try JSONDecoder().decode([MainCategory].self, from: data)
                for item in categories{
                    self.countOfItems += 1
                    let category = MainCategory(title: item.title, subs: item.subs)
                    self.articles.append(category)
                    printCategoryFromMain(item: item)
                    print(self.countOfItems)
                }
            }
            catch let JsonErr{
                print(JsonErr)
            }
        }.resume()
        
        func printCategoryFromMain(item: JSONTest.ViewController.MainCategory) {
            for item in item.subs{
                self.countOfItems += 1
                if (item.subs != nil){
                    printPodcategoryFromPodcategory(item: item)
                }
            }
        }
        
        func printPodcategoryFromPodcategory(item: JSONTest.ViewController.Category){
            for item in item.subs!{
                self.countOfItems += 1
                if (item.subs != nil){
                    printPodcategoryFromPodcategory(item: item)
                }
            }
        }
    }
    
    
    
}

