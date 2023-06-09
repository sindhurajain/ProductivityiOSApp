
import RealmSwift
import UIKit

class EventInfo: Object{
@objc dynamic var title: String = ""
@objc dynamic var event: String = ""

}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var deletionHandler: (() -> Void)? //realm
 @IBOutlet var table: UITableView!
  // @IBOutlet var label: UILabel! //hidden label, deleted
 private let realm = try! Realm()//realm
   private var models = [EventInfo]()//realm

  
   override func viewDidLoad() {
      super.viewDidLoad()
    models = realm.objects(EventInfo.self).map({ $0 }) //realm
    table.delegate = self
  table.dataSource = self
title = "Events"
    }
   @IBAction func didTapNewEvent(){
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "new") as? NewEvent else{
    return
}
      vc.title = "New Event"
      vc.navigationItem.largeTitleDisplayMode = .never
 vc.completion = { eventTitle, event in
          self.navigationController?.popToRootViewController(animated: true)
           
   self.models = self.realm.objects(EventInfo.self).map({ $0 })
       self.table.reloadData()
 }
    navigationController?.pushViewController(vc, animated: true)
   }
    

    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
             return models.count
  }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = models[indexPath.row].title
     cell.detailTextLabel?.text = models[indexPath.row].event

      return cell
   }


      //  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
          //  if editingStyle == .delete{
        //        tableView.beginUpdates()
          //      tableView.deleteRows(at: [indexPath], with: .fade)
         //       tableView.endUpdates()//    }
        //    else if editingStyle == .insert{
         //       print("insert")
      //      }
     //   }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
realm.beginWrite()
        realm.delete(models.remove(at: indexPath.row))
            
            //from here
        tableView.deleteRows(at: [indexPath], with: .fade)
            try! realm.commitWrite()
            deletionHandler?() //fixthis
           
           tableView.endUpdates()
       } else if editingStyle == .insert {
       }
   }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }
            
  //to here
            
 
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
        
    let model = models[indexPath.row]
      guard let vc = storyboard?.instantiateViewController(withIdentifier: "event") as? EventViewController else{
          return
      }
    vc.deletionHandler = { [weak self] in
          self?.refresh()
       }
        
        vc.navigationItem.largeTitleDisplayMode = .never
    
    
        vc.title = model.title
        vc.eventTitle = model.title
        vc.event = model.event
        navigationController?.pushViewController(vc, animated: true)
      }
        
   
func refresh(){
 self.models = self.realm.objects(EventInfo.self).map({ $0 })//realm
 self.table.reloadData()
}
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
      return .delete
    }

    
}




