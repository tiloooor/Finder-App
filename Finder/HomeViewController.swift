//
//  HomeViewController.swift
//  Finder
//
//  Created by Claire Chen on 7/13/17.
//  Copyright © 2017 Finder. All rights reserved.
//

import UIKit
import Koloda
import Parse
import KRProgressHUD

private var numberOfCards: Int = 3

func randomColor() -> UIColor {
    var randomRed:CGFloat = CGFloat(arc4random_uniform(256))
    var randomGreen:CGFloat = CGFloat(arc4random_uniform(256))
    var randomBlue:CGFloat = CGFloat(arc4random_uniform(256))
    return UIColor(red:   randomRed/255,
                   green: randomGreen/255,
                   blue:  randomBlue/255,
                   alpha: 1.0)
}

func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint) -> UIImage{
    
    // Setup the font specific variables
    let textColor: UIColor = randomColor() //UIColor.white
    let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 26)!
    let paraStyle = NSMutableParagraphStyle()
    
    //Setup the image context using the passed image.
    UIGraphicsBeginImageContext(inImage.size)
    
    //alignment
    paraStyle.alignment = .center
    
    //Setups up the font attributes that will be later used to dictate how the text should be drawn
    let textFontAttributes = [
        NSFontAttributeName: textFont,
        NSForegroundColorAttributeName: textColor,
        NSParagraphStyleAttributeName: paraStyle
        ]
    
    //Put the image into a rectangle as large as the original image.
    inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
    
    // Creating a point within the space that is as bit as the image.
    let textSize = drawText.size(attributes: textFontAttributes)
    //let textRect = CGRect(x: inImage.size.width / 2 - textFont.width / 2, y: 0,
    //                      width: inImage.size.width / 2 + textSize.width / 2, height: inImage.size.height - textFont.height)
    let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
    
    
    //Now Draw the text into an image.
    drawText.draw(in: rect, withAttributes: textFontAttributes)
    
    // Create a new image out of the images we have created
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    
    // End the context now that we have the image we need
    UIGraphicsEndImageContext()
    
    //And pass it back up to the caller.
    return newImage
}

//Function to create facts
func makeFacts(){
    //hardcoded 5 facts
    Fact.postFact(source: "Urban Dictionary", withCaption: "coffeee is a drink maybe") { (success: Bool, error: Error?) in
        if success {
            print("saved correctely")
        } else {
            print("nah fam")
        }
    }
    //
    Fact.postFact(source: "CNN", withCaption: "is a news source") { (success: Bool, error: Error?) in
        if success {
            print("saved correctely")
        } else {
            print("nah fam")
        }
    }
    //
    Fact.postFact(source: "LOL", withCaption: "appp timeline search results commits how do i resolve add two") { (success: Bool, error: Error?) in
        if success {
            print("saved correctely")
        } else {
            print("nah fam")
        }
    }
    //
    Fact.postFact(source: "Blu HArbor", withCaption: "hoem hoem hoem homeeeeeeee when to go home") { (success: Bool, error: Error?) in
        if success {
            print("saved correctely")
        } else {
            print("nah fam")
        }
    }
    //
    Fact.postFact(source: "jeeeez", withCaption: "food is the best thing to happen to mankind") { (success: Bool, error: Error?) in
        if success {
            print("saved correctely")
        } else {
            print("nah fam")
        }
    }
}

func getFacts() -> [PFObject] {
    var facts: [PFObject] = []
    //makeFacts()
    KRProgressHUD.show()
    let query = PFQuery(className: "Fact")
    query.addDescendingOrder("createdAt")
    query.limit = 5
    //syncronous fetch
    
    do {
        facts = try query.findObjects()
        print("get facts succes")
    } catch {
        facts = []
        print("error")
    }
//    query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
//        if error == nil {
//            facts = posts!
//            print("all is well")
//        } else {
//            print(error ?? "ERROR")
//        }
//        
//    }
    KRProgressHUD.dismiss()
    return facts
    
}

class HomeViewController: UIViewController {
    
    //Helpers
    
    //Outlet
    @IBOutlet var kolodaView: KolodaView!
    
    //Variables
    var facts: [PFObject] = []
    fileprivate var dataSource: [UIImage] = []
//    fileprivate var dataSource: [UIImage] = {
//        let facs = getFacts()
//        var array: [UIImage] = []
//        print(facs.count)
//        for index in 0..<facs.count {
//            let base = UIImage(named: "Card_like")
//            let point = CGPoint(x: 10, y: 10)
//            let curFact: PFObject = facs[index]
//            let str = curFact["fact"] as? NSString
//            print("\(str) \(index)")
//            array.append(textToImage(drawText: str!, inImage: base!, atPoint: point))
//        }
//        
//        return array
//    }()
    
    func createImages(facts:[PFObject]) -> [UIImage] {
        var array: [UIImage] = []
        print(facts.count)
        for index in 0..<facts.count {
            let base = UIImage(named: "Card_like")
            let point = CGPoint(x: 10, y: 10)
            let curFact: PFObject = facts[index]
            let str = curFact["fact"] as? NSString
            print("\(str) \(index)")
            array.append(textToImage(drawText: str!, inImage: base!, atPoint: point))
        }
        return array
    }

    //OnTap
    @IBAction func onReadMore(_ sender: Any) {
        self.performSegue(withIdentifier: "readMoreSegue", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facts = getFacts()
        dataSource = createImages(facts: facts)
        kolodaView.dataSource = self
        kolodaView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    // MARK: IBActions
    
//    @IBAction func leftButtonTapped() {
//        kolodaView?.swipe(.left)
//    }
//    
//    @IBAction func rightButtonTapped() {
//        kolodaView?.swipe(.right)
//    }
//    
//    @IBAction func undoButtonTapped() {
//        kolodaView?.revertAction()
//    }


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

// MARK: KolodaViewDelegate

extension HomeViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("in")
        let newFacts = getFacts()
        //add new facts to facts
        facts.append(contentsOf: newFacts)
        print("ok")
        let images = createImages(facts: newFacts)
        print("damn bbu")
        let position = kolodaView.currentCardIndex
        print("pos")
        for image in images {
            print("each")
            dataSource.append(image)
            print("appended")
        }
        print("tssss")
        kolodaView.insertCardAtIndexRange(position..<position + images.count, animated: true)
        print("done")
    }
    
//    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
//    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(direction)
        print(facts.count)
        let fact: PFObject = facts[index]
        print(fact["fact"])
        //print(facts[index]["fact"])
    }
}

// MARK: KolodaViewDataSource

extension HomeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: dataSource[Int(index)])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

