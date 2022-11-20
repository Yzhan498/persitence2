//
//  ViewController.swift
//  persistence1
//
//  Created by ying zhang on 2022-11-18.
//

import UIKit
class ViewController: UIViewController{
    fileprivate static let rootKey = "rootKey"
    @IBOutlet var lineFields:[UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileURL = self.dataFileURL()
              if (FileManager.default.fileExists(atPath: fileURL.path!)) {
                  if let array = NSArray(contentsOf: fileURL as URL) as? [String] {
                      for i in 0..<array.count {
                          lineFields[i].text = array[i]
                      }
                  }
                  let data = NSData(contentsOf: fileURL as URL)
                  do{
                      let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data! as Data)
                      let fourLines = unarchiver.decodeObject(forKey: ViewController.rootKey) as!FourLines
                      unarchiver.finishDecoding()
                      
                      if let newLines = fourLines.lines {
                          for i in 0..<newLines.count {
                              lineFields[i].text = newLines[i]
                          }
                      }
                  }catch
                  {
                      print("error")
                  }
                 
              }
        let app = UIApplication.shared
        
        //Register for the applicationWillResignActive anywhere in your app.
        NotificationCenter.default.addObserver(self,selector:#selector(self.applicationWillResignActive(notification:)), name: UIScene.willDeactivateNotification, object: app)
    }
    @objc func applicationWillResignActive(notification: NSNotification) {
        let fileURL = self.dataFileURL()
        let fourLines = FourLines()
        let array = (self.lineFields as NSArray).value(forKey: "text") as! [String]
        fourLines.lines = array
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver.init(requiringSecureCoding: true)
        archiver.encode(fourLines, forKey: ViewController.rootKey)
        archiver.finishEncoding()
        data.write(to: fileURL as URL, atomically: true)
    }
    func dataFileURL() -> NSURL {
        let urls = FileManager.default.urls(for:
                .documentDirectory, in: .userDomainMask)
        var url:NSURL?
        // create a blank path
        url = URL(fileURLWithPath: "") as NSURL?
        do {
            url = urls.first?.appendingPathComponent("data.plist") as NSURL?
        }
        return url!
    }
}
