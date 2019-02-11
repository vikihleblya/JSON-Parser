import UIKit

class MainViewController: UITableViewController {

    fileprivate var countOfItems: Int = 0
    fileprivate var categories = [Category]()
    let db = Database()
    let cellId = "cellId"
    
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        refreshData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.createTable()
        db.deleteAllRows()
        if(db.checkTableIsEmpty() == false){
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                self.getDataFromJson()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        else{
            self.categories = db.queryAllRows()
            print(categories)
        }
        
    }
    
    func refreshData(){
        
    }
    
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


//  MARK: Work with tableView

extension MainViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
}

