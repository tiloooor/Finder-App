//
//  customTabBar.swift
//  Finder
//
//  Created by Tyler Holloway on 8/2/17.
//  Copyright © 2017 Finder. All rights reserved.
//

import UIKit

class customTabBar: UITabBarController {
    
    let customButton = UIButton.init(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customButton.setTitle("Cards", for: .normal)
        customButton.setTitleColor(.white, for: .normal)
        customButton.setTitleColor(.yellow, for: .highlighted)
        customButton.frame = CGRect(x: 100, y: 0, width: 44, height: 44)
        customButton.backgroundColor = .green
        //customButton.layer.borderWidth = 4
        customButton.addTarget(self, action: #selector(goToCardsViewController), for: .touchUpInside)
        
        self.view.insertSubview(customButton, aboveSubview: self.tabBar)
        
        
        
    }
    
    func goToCardsViewController() {
        
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "toCards") as! ToCardsController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
        customButton.layer.cornerRadius = 32
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
