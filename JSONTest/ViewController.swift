import UIKit

class ViewController: UITableViewController {

    fileprivate var articles = [Category]()
    fileprivate var categories = [String]()
    fileprivate var countOfItems: Int = 0
    let db = Database()
    let cellId = "cellId"
    
    struct Category: Decodable {
        let id: Int?
        let title: String
        let subs: [Category]?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articles.removeAll()
        //getDataFromJson()
        db.createTable()
        db.deleteAllRows()
        db.checkTableIsEmpty()
//        db.queryAllRows()
    }
    
    func getDataFromJson(){
        let stringUrl = "https://money.yandex.ru/api/categories-list"
        guard let url = URL(string: stringUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do{
                let categories = try JSONDecoder().decode([Category].self, from: data)
                for item in categories{
                    self.db.insert(id: item.id ?? 0, title: item.title)
                    let category = Category(id: item.id, title: item.title, subs: item.subs)
                    self.articles.append(category)
                    self.categories.append(item.title)
                    self.getCategory(item: item)
                }
            }
            catch let JsonErr{
                print(JsonErr)}}
            .resume()
    }
    
    func getCategory(item: JSONTest.ViewController.Category) {
        for item in item.subs ?? []{
            self.categories.append(item.title)
            self.db.insert(id: item.id ?? 0, title: item.title)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if (item.subs != nil){
                getCategory(item: item)
            }
        }
    }
    

    
}


//  MARK: Work with tableView

extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
}

