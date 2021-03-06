//
//  PostTableViewCell.swift
//  Finder
//
//  Created by Tyler Holloway on 7/11/17.
//  Copyright © 2017 Finder. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class PostTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    
    @IBOutlet weak var factText: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var trayView: UIView!
    

    
    // Poll
    @IBOutlet weak var trueBar: UIProgressView!
    @IBOutlet weak var falseBar: UIProgressView!
    
    var timesTapped: Float = 0.0
    var timesFalseTapped: Float = 0.0
    
    
    var trayOriginalCenter: CGPoint!
    var startLocation: CGPoint!
    var trayAtBottom = true
    
    
    var post: PFObject! {
        didSet {
            let author = post["authorId"] as? PFUser
            
            
            //
            //            if didLikePost == "true" {
            //                likeButton.isSelected = true
            //            } else {
            //                likeButton.isSelected = false
            //            }
            
            
            
            if let creationTime = post["creationTime"] {
                let postDateFormatter: DateFormatter = {
                    let f = DateFormatter()
                    f.dateFormat = "MMM d, yyyy"
                    return f
                }()
                self.timeStamp.text = postDateFormatter.string(from: Date(timeIntervalSinceReferenceDate: creationTime as! TimeInterval))
                
            }
            
            if let user = post["authorId"] as? PFUser {
                self.usernameLabel.text = user.username
            } else {
                self.usernameLabel.text = " "
            }
            self.factText.text = post["caption"] as? String
            
        }
        
        
    }
    
    override func awakeFromNib() {     //53 163 152 | 95 186 131
        super.awakeFromNib()
        // Initialization code
        
        var ourYellow = UIColor(red: 249/255, green: 208/255, blue: 16/255, alpha: 1)
        
        trayView.backgroundColor = UIColor.black
        usernameLabel.textColor = UIColor.white
        //timeStamp.textColor = ourYellow
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.trayView.addGestureRecognizer(gestureRecognizer)
        trayView.center.y = (contentView.bounds.size.height) + 80
        
        
        trayView.layer.cornerRadius = 30
        trayView.layer.borderWidth = 5
        trayView.layer.borderColor = ourYellow.cgColor
        //trayView.layer.borderColor = UIColor.black.cgColor
        
        // Poll
        self.timesTapped = 0
        self.trueBar.progress = 0
        
        self.timesFalseTapped = 0
        self.falseBar.progress = 0
        
        trueBar.transform = trueBar.transform.scaledBy(x: 1, y: 10)
        falseBar.transform = falseBar.transform.scaledBy(x: 1, y: 10)
        
    }
    
    
    @IBAction func pressTrue(_ sender: Any) {
        self.timesTapped += 0.1
        
        
        if self.timesTapped == 1.0 {
            self.trueBar.progress = 1.0
            return
        }
            self.trueBar.progress = timesTapped

    }
    
    
    
    @IBAction func pressFalse(_ sender: Any) {
        self.timesFalseTapped += 0.1
        
        if self.timesFalseTapped == 0 {
            self.falseBar.progress = 1.0
            return
        }
        
        self.falseBar.progress = timesFalseTapped
    }
    
    
    
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        var translation = gestureRecognizer.translation(in: trayView)
        //print("translation \(translation)")
        //print("contentView \(contentView.center)")
        let velocity = gestureRecognizer.velocity(in: trayView)
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            trayOriginalCenter = trayView.center
            
        } else if gestureRecognizer.state == UIGestureRecognizerState.changed {
            if (trayAtBottom && velocity.y > 0) || (!trayAtBottom && velocity.y < 0){
                //do nnothing
            } else {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            }
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            if velocity.y < 0{ //swipe up
                UIView.animate(withDuration: 0.3, animations: {
                    self.trayView.center = self.contentView.center
                    self.trayAtBottom = false
                })
                
            } else { //swipe down
                UIView.animate(withDuration: 0.3, animations: {
                    self.trayView.center.y = (self.contentView.bounds.size.height) + 80
                    self.trayAtBottom = true
                })
            }
            
        }
        
    }
    
    
    func getRandomImae() {
        
        
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
