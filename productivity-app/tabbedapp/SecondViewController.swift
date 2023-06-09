
import RealmSwift
import UIKit
import UserNotifications


class ToDoListItem: Object{
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()

    
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var deletionHandler: (() -> Void)?
    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
  
    private let realm = try! Realm()
    private var data = [ToDoListItem]()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return dateFormatter
    } ()
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(ToDoListItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        

    }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
cell.textLabel?.text = data[indexPath.row].item
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "\(data[indexPath.row].item) on \(Self.dateFormatter.string(from: data[indexPath.row].date))"
            
            
        let date = data[indexPath.row].date.addingTimeInterval(0)
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            center.add(request) { (error) in
                
            }
        return cell

    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           tableView.beginUpdates()
            realm.beginWrite()
        realm.delete(data.remove(at: indexPath.row))
        tableView.deleteRows(at: [indexPath], with: .fade)
            try! realm.commitWrite()
        deletionHandler?()
           
           tableView.endUpdates()
       } else if editingStyle == .insert {
       }
   }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = data[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else{
            return
        }

        
        
        vc.item = item  
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
    }
    

    

    
    
    @IBAction func didTapAddButton() {
guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else{
            return
        }
        
       vc.completionHandler = {
        
        [weak self] in
                  self?.refresh()
              }
              

        
        
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        
      

    }
    func refresh(){
        data = realm.objects(ToDoListItem.self).map({ $0 })
        table.reloadData()
    }
    
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
      return .delete
  }

}



