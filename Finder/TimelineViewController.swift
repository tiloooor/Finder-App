//
//  TimelineViewController.swift
//  Finder
//
//  Created by Tyler Holloway on 7/11/17.
//  Copyright © 2017 Finder. All rights reserved.
//

import UIKit
import Parse


class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: Properties
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIBarButtonItem!
 
    
    var post: [PFObject]? = []
    
    var cards: [PFObject]? = []
    
    // Array of articles249/255, green: 208/255, blue: 16/255
    var arr = [Recommended]()
    // Destination to full article
    var dest_url : String!
    
    var interest: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up delegates
        //self.tableview.delegate = self
        self.tableview.dataSource = self
        
        get_data()
        sideMenus()
        updatePosts()
        updateTL()
        
        // Set up Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableview.insertSubview(refreshControl, at: 0)
        
        // Change navigation bar title font
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 17)!]
    
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // this method is an extension of the UIViewController
        // so using self works as you might expect.
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Default is "true" so this sets it to false tells it to use
        // the storyboard as you have it placed
        // and not how it thinks it should place it.
    }



    func updatePosts() {
        // Construct query
        let query = PFQuery(className: "Post")
        query.order(byDescending: "creationTime")
        query.limit = 20
        query.includeKey("authorId")
        //query.includeKey("caption")
        
        
        query.findObjectsInBackground { (posts: [PFObject]?,
            error: Error?) in
            if let posts = posts {
                self.post = posts
                self.tableview.reloadData()
            } else {
                print(String(describing: error?.localizedDescription))
            }
        }
    }
    
    func updateTL(){
        let curUser = PFUser.current()
        let query = PFQuery(className: "Timeline")
        query.includeKey("author")
        query.whereKey("owner", equalTo: curUser?.objectId)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if error == nil {
                self.cards = results
                self.tableview.reloadData()
            } else {
                print("errorerrorerrorerror")
            }
        }
    }

    
    // Refresh Control
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        updatePosts()
        refreshControl.endRefreshing()
    }
    
    
    
    var isMoreDataLoading = false
    
    // Infinite Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            
            let scrollViewContentHeight = tableview.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableview.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableview.isDragging) {
                isMoreDataLoading = true
                
            // Code to load more results
            get_data()
            //updatePosts()
            
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count /*+ post!.count*/
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < post!.count && indexPath.row % 3 == 0{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell") as! PostTableViewCell
            let posts = post?[indexPath.row]
            cell.post = post?[indexPath.row]
           tableview.rowHeight = 289
            return cell
            
            
        } else if (indexPath.row < cards!.count && indexPath.row % 2 == 0) {
            
            let cellThree = tableView.dequeueReusableCell(withIdentifier: "cardTableViewCell", for: indexPath) as! TLCell
            
            print(cards)
            cellThree.card = cards?[indexPath.row]
            tableview.rowHeight = 289
            
            return cellThree
            
            
        } else {
            let cellTwo = tableView.dequeueReusableCell(withIdentifier: "recommended", for: indexPath) as! RecommendedTableViewCell
            
            
            cellTwo.recommend = arr[indexPath.row]
            tableview.rowHeight = 430
            
            return cellTwo

            
        }
        
        
    }
    
    
    
    
    // Fetch the data from the API
    func get_data ()
    {
        var currentUser = PFUser.current()
        
        // User interest
        
        if (interest = currentUser?.object(forKey: "interests") as! [String]) != nil {
            print("This string is not empty")
        } else {
            print("This string is empty")
        }
        
        
        print(interest ?? "No interest")
        
        var firstInterest = interest.first
        print(firstInterest! ?? "entertainment")
        
        var articleUrl: String
        
        if firstInterest == "history" {
            articleUrl = " https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=dac06852b2574464ad33ca8902bcb418"
        } else if firstInterest == "sports"{
            articleUrl = "https://newsapi.org/v1/articles?source=espn&sortBy=top&apiKey=dac06852b2574464ad33ca8902bcb418"
        } else if firstInterest == "politics"{
            articleUrl = "https://newsapi.org/v1/articles?source=cnn&sortBy=top&apiKey=dac06852b2574464ad33ca8902bcb418"
        } else if firstInterest == "technology"{
            articleUrl = "https://newsapi.org/v1/articles?source=techradar&sortBy=top&apiKey=dac06852b2574464ad33ca8902bcb418"
        } else if firstInterest == "fashion"{
            articleUrl = "https://newsapi.org/v1/articles?source=entertainment-weekly&sortBy=top&apiKey=dac06852b2574464ad33ca8902bcb418"
        } else {
            articleUrl = "https://newsapi.org/v1/articles?source=the-next-web&sortBy=latest&apiKey=112947519e4a41e48da28e8c35965f7b"
        }
        
        print(articleUrl)

            let apiurl = NSURL(string: articleUrl);
        
            let task = URLSession.shared.dataTask(with: apiurl! as URL) {
                
                
                (data,response,error) in
                
                if error != nil {
                    print (error)
                    return
                    
                }
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let d = json["articles"] as! [[String: AnyObject]]
                    print(d)
                    for items in d
                    {
                        let title = items["title"]!
                        let imgUrl = items["urlToImage"]! as! String
                        //let imgParsedUrl = URL(string: imgUrl)!
                        let dataurl = items["url"]!;
                        //let img = self.imageParsed(imgData: imgParsedUrl);
                        let desc = items["description"]
                        let publishedAt = items["publishedAt"] as? String ?? "21m"
                       // let lang = items["language"]
                        
                        let NewPost = Recommended(Title: title as! String, sendURL: dataurl as! String, PostImage: imgUrl, Desc: desc as! String, publishedAt: publishedAt as! String)
                        self.arr.append(NewPost)
                        
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                            
                        }
                    }
                    
                }
                catch let jError {
                    
                    print (jError)
                    
                }
                
                //let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print(str)
                
                
            }
                   task.resume()
            
        

    }
    
    
//    // Segue to full article
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if (segue.identifier == "webSeg") {
//            
//            
//            let viewController = segue.destination as! FullArticleViewController
//            viewController.dest_url = dest_url
//        }
//    }
    
    // Implement side menu
    func sideMenus() {
        
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 300
            
            
//            mapButton.target = revealViewController()
//            mapButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    

    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
