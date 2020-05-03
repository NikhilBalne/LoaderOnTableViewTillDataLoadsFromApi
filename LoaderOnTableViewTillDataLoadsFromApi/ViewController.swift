//
//  ViewController.swift
//  LoaderOnTableViewTillDataLoadsFromApi
//
//  Created by Nikhil Balne on 03/05/20.
//  Copyright © 2020 Nikhil Balne. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var indicator = UIActivityIndicatorView()

    @IBOutlet weak var postsTableView: UITableView!
    var postTableDataArray = [PostsModel]()
    let postsReusableIdentifier = "postsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        self.postsTableView.register(UITableViewCell.self, forCellReuseIdentifier: postsReusableIdentifier)
        self.postsTableView.separatorColor = .clear
        makePostsGetServiceCall()
    }

    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func makePostsGetServiceCall(){
        let url = URL(string: "\(baseUrl)posts")
    
        AF.request(url!).response{
            response in
            if (response.response?.statusCode == 200){
                if let data = response.data {
                    do {
                        let usersResponse = try JSONDecoder().decode([PostsModel].self, from: data)
                        self.postTableDataArray.append(contentsOf: usersResponse)
                        DispatchQueue.main.async {
                            self.indicator.stopAnimating()
                            self.indicator.hidesWhenStopped = true
                            self.postsTableView.separatorColor = .lightGray
                            self.postsTableView.reloadData()
                        }
                    }catch let error {
                        print("Error:\(error.localizedDescription)")
                    }
                }
            }else{
                print("StatusCode:\(response.response!.statusCode)")
            }
        }
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postTableDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postTableCell =  self.postsTableView.dequeueReusableCell(withIdentifier: postsReusableIdentifier)!
        let postsObject = self.postTableDataArray[indexPath.row]
        postTableCell.textLabel?.text = postsObject.title
        return postTableCell
    }
    
}

