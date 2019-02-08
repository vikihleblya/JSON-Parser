import UIKit

class ViewController: UITableViewController {

    fileprivate var articles = [Category]()
    fileprivate var countOfItems: Int = 0
    
    struct Category: Decodable {
        let id: Int?
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
                let categories = try JSONDecoder().decode([Category].self, from: data)
                for item in categories{
                    self.countOfItems += 1
                    let category = Category(id: item.id, title: item.title, subs: item.subs)
                    self.articles.append(category)
                    print(item.title)
                    printCategory(item: item)
                    print(self.countOfItems)
                }
            }
            catch let JsonErr{
                print(JsonErr)
            }
        }.resume()
        
        func printCategory(item: JSONTest.ViewController.Category) {
            for item in item.subs ?? []{
                self.countOfItems += 1
                print(item.title)
                if (item.subs != nil){
                    printCategory(item: item)
                }
            }
        }
        

    }
    
    
    
}

