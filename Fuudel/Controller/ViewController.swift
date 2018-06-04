//
//  ViewController.swift
//  Fuudel
//
//  Created by Zert Interactive on 6/4/18.
//  Copyright © 2018 Zert Interactive. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var fuddelTableView: UITableView!
    fileprivate var fuudelArray = [FuudelModel]()
    fileprivate var filteredProductArray = [FuudelModel]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let _ = customActivityIndicatory(self.view, startAnimate: true)
        self.getFuudelData()
        self.registerCutomCell()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Fuudel"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCutomCell(){
        
        self.fuddelTableView.register(UINib(nibName: "FuudelTableViewCell", bundle: nil), forCellReuseIdentifier: "fuddelCell")
    }
    
    func configureTableViewDelegate(){
        
        self.fuddelTableView.delegate = self
        self.fuddelTableView.dataSource = self;
    }
    
    func addSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search product"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func filterProductForSearchText(_ searchText: String) {
        filteredProductArray = fuudelArray.filter({( product : FuudelModel) -> Bool in
            
            if searchBarIsEmpty() {
                return true
            } else {
                return  product.ProductName.lowercased().contains(searchText.lowercased())
            }
        })
        
        DispatchQueue.main.async {
            self.fuddelTableView.reloadData()
            
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    
    func showEmptyProduct(){
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.fuddelTableView.bounds.size.width, height: self.fuddelTableView.bounds.size.height))
        messageLabel.text = "No Product Found"
        if self.view.frame.size.height > 568.0 {
            messageLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        }else{
            messageLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
            
        }
        
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.fuddelTableView.backgroundView = messageLabel
        
    }
    
    
    
}
extension ViewController:UITableViewDataSource,UITableViewDelegate,FuudelTableViewCellDelegate,CreateItemControllerDelegate{
    
    // .....Pragma mark - UITableViewDataSource & UITableViewDelegate implementation starts.....

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if filteredProductArray.isEmpty{
            showEmptyProduct()
        }else{
            self.fuddelTableView.backgroundView = nil
        }
        return filteredProductArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fuddelCell = tableView.dequeueReusableCell(withIdentifier: "fuddelCell", for: indexPath) as! FuudelTableViewCell
        fuddelCell.delegate = self
        let tempFuudelData = filteredProductArray[indexPath.row] as FuudelModel
        fuddelCell.fuudel = tempFuudelData
        
        return fuddelCell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // .....Pragma mark - UITableViewDataSource & UITableViewDelegate implementation ends.....

    
    //.............
    
    // .....Pragma mark - FuudelTableViewCellDelegate implementation starts.....

    
    func fuudelTableViewCellDidTapCreate(_ sender: FuudelTableViewCell) {
        
        if let createItemController = self.storyboard?.instantiateViewController(withIdentifier: "createitem") as? CreteItemController{
            createItemController.createItemDelegate = self
            self.navigationController?.pushViewController(createItemController, animated: true)
        }
        
    }
    
    func fuudelTableViewCellDidTapDelete(_ sender: FuudelTableViewCell) {
        
        if let indexPath = self.fuddelTableView .indexPath(for: sender){
            
            self.fuudelArray.remove(at: indexPath.row)
            self.filteredProductArray = fuudelArray
            self.fuddelTableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        
    }
    
    // .....Pragma mark - FuudelTableViewCellDelegate implementation ends.....

    //............
    
    // .....Pragma mark - CreateItemControllerDelegate implementation starts.....

    
    func createItemControllerDidTapOnCreate(_ newItem: FuudelModel) {
        fuudelArray.append(newItem)
        filteredProductArray = fuudelArray
        DispatchQueue.main.async {
            self.fuddelTableView.reloadData()
        }
    }
    
    // .....Pragma mark - CreateItemControllerDelegate implementation ends.....

    
    
    
}


// .....Pragma mark - UISearchResultsUpdating implementation Starts.....

extension ViewController : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterProductForSearchText((searchController.searchBar.text?.trimmingCharacters(in: .whitespaces))!)
        
    }
    
    
}

// .....Pragma mark - UISearchResultsUpdating implementation ends.....


// .....Pragma mark - Other Customs functionality  implementation Starts.....

extension ViewController{
    
    fileprivate func getFuudelData(){
        let urlEndPoint: String = "http://77.68.80.27:4010/marketplaceapi/getsubmenulistbycategoryid?&categoryid=351&pageindex=1&pagesize=1000&resturentid=1"
        guard let url = URL(string: urlEndPoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        
        let session = URLSession(configuration:URLSessionConfiguration.default)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET ")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            
            
            do {
                guard let rootDict = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                if  let porductArray = rootDict["data"] as? [[String : Any]]{
                    
                    for product in porductArray{
                        self.fuudelArray.append(FuudelModel(ProductName: product["ProductName"] as! String, SDetails: product["Details"] as! String, Price:product["Price"] as! Double))
                    }
                }
                
                if !self.fuudelArray.isEmpty{
                    DispatchQueue.main.async {
                        let _ = self.customActivityIndicatory(self.view, startAnimate: false)
                        self.addSearchController()
                        self.configureTableViewDelegate()
                        self.filteredProductArray = self.fuudelArray
                        self.fuddelTableView.reloadData()
                    }
                }
                
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
            
        }
        
        task.resume()
    }
    
    fileprivate func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        //mainContainer.backgroundColor = UIColor.white
        //mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha:1.0)
        //  viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
    }
    
}

