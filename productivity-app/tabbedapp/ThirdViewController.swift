
import RealmSwift
import UIKit
//import NotificationBannerSwift
//class Countdown: Object{
 //@objc dynamic var hours: Int = 0
// @objc dynamic var min: Int = 0
 //@objc dynamic var s: Int = 0
    
//}

class ThirdViewController: UIViewController {
    
    public var deletionHandler: (() -> Void)?
    private let realm = try! Realm()
    //private var stuff = [Countdown]()

    @IBOutlet var label: UILabel!
var hours: Int = 0
var min: Int = 0
var s: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//stuff = realm.objects(Countdown.self).map({ $0 })
        
    }

    @IBAction func didtapaddbutton(){
        let vc = storyboard?.instantiateViewController(identifier: "date_picker") as! DateViewController
        vc.title = "New Event"
        vc.completionHandler = { [weak self] name, date in
            DispatchQueue.main.async{
                self?.didCreateEvent(name: name, targetDate: date)

            }
           // stuff = realm.objects(Countdown.self).map({ $0 })


        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func didCreateEvent(name: String, targetDate: Date){
       // stuff = realm.objects(Countdown.self).map({ $0 })
        self.title = name
        let difference = floor(targetDate.timeIntervalSince(Date()))
        if difference > 0.0{
            let computedHours: Int = Int(difference) / 3600
            let remainder: Int = Int(difference) - (computedHours * 3600)
            let minutes: Int = remainder / 60
            let seconds: Int = Int(difference) - (computedHours * 3600) - (minutes * 60)
      print("\(computedHours) \(minutes) \(seconds)")
            hours = computedHours
            min = minutes
            s = seconds
            updateLabel()
            startTimer()
        }
            
            
        else{
            print("negative interval")
        }
    }
           
    
    private func startTimer(){
       // stuff = realm.objects(Countdown.self).map({ $0 })

    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
        if self.s > 0{
            self.s = self.s - 1
        }
        else if self.min > 0 && self.s == 0 {
            self.min = self.min - 1
            self.s = 59
        }
               
        else if self.hours > 0 && self.min == 0 && self.s == 0{
            self.hours = self.hours - 1
            self.min = 59
            self.s = 59
        }
        
        self.updateLabel()
        
        self.realm.beginWrite()
        try! self.realm.commitWrite()
        self.deletionHandler?()
        
   //  if self.hours == 0 && self.min == 0 && self.s == 0{

    //    let banner = GrowingNotificationBanner (title: "Countdown Over", style: .success, colors: nil)
    //    banner.show()
    //     banner.autoDismiss = true
     //   banner.dismissOnTap = true
      //  banner.dismissOnSwipeUp = true
        
        
    //    banner.remove()
     //}
    
  
     })
    }
    private func updateLabel(){
  //      stuff = realm.objects(Countdown.self).map({ $0 })
        label.text = "\(hours): \(min): \(s)"
    }
    
    
   
}
