//
//  Alerts.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 22/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import UIKit

class Alerts:NSObject{
    
    
    //variables:
    var view:UIViewController
    var title:String
    var message:String
    var option1title:String
    var option1Action:()->Void
    var option2title:String
    var option2Action:()->Void
    
    //alert with two options
    init(view:UIViewController, title:String,message:String,option1title:String,option1Action:@escaping ()->Void, option2title:String, option2Action:@escaping ()->Void) {
        self.view = view
        self.title = title
        self.message = message
        self.option1title=option1title
        self.option1Action=option1Action
        self.option2title=option2title
        self.option2Action=option2Action
    }
    
    func showAlertWithTwoOptions(){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: option1title,
                                      style: .default,
                                      handler: { (UIAlert) in
            self.option1Action()
        }))
        
        alert.addAction(UIAlertAction(title: option2title,
                                      style: .default,
                                      handler: { (UIAlert) in
            self.option2Action()
        }))
        
        view.present(alert, animated: true, completion: nil)
    }
    
    //alert with one option
}
