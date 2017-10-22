//
//  ABProfileViewController.swift
//  Abring Demo
//
//  Created by Hosein on 5/9/1396 AP.
//  Copyright © 1396 AP AsemanLTD. All rights reserved.
//

import UIKit


public class ABRProfileViewController: UITableViewController , UITextFieldDelegate {
    
    public var headerBackgroundColor = ABRAppConfig.tintColor
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView = UITableView(frame: CGRect.zero , style: .grouped)
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        tableView.separatorInset = UIEdgeInsets.zero
        
        registerNibs()
//        getUser()
        fillHeader()
        
    
        
        
    }

    
    //MARK: Table View Header
    
    func fillHeader() {
        let header = tableView.tableHeaderView as? ABRProfileHeader
        header?.nameLabel.text = ABRPlayer.current()?.mobile
        header?.loadActivity.isHidden = false
        header?.loadActivity.startAnimating()
        header?.editButton.addTarget(self, action: #selector(editAction(_:)) , for: .touchUpInside)
        
        let pictureURL : URL?
        if let avatar = ABRPlayer.current()?.avatarUrl {
            pictureURL = URL(string: avatar)
            if pictureURL != nil {
                downloadImage(pictureURL!, completion: { (image) in
                    DispatchQueue.main.async {
                        header?.avatarImageView.image = image
                        header?.loadActivity.stopAnimating()
                    }
                })
            }
            
        } else {
            return
        }
    }
    
    @objc func editAction(_ sender : ABRSwitchableButton?) {
        tableView.reloadData()
    }
    
    func downloadImage(_ path : URL , completion : @escaping (_ image : UIImage?) -> Void) {
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: path) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        completion(image)
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    func registerNibs() {
        if Bundle.main.path(forResource: "ABRProfileRow", ofType: "nib") != nil {
            let row = UINib(nibName: "ABRProfileRow", bundle: Bundle.main)
            tableView.register(row, forCellReuseIdentifier: "profileRow")
        } else {
            let row = UINib(nibName: "ABRProfileRow", bundle: Bundle.init(for: ABRProfileRowCell.self))
            tableView.register(row, forCellReuseIdentifier: "profileRow")
        }
        
        if Bundle.main.path(forResource: "ABRProfileHeader", ofType: "nib") != nil {
            let userNib = UINib(nibName: "ABRProfileHeader", bundle: Bundle.main)
            tableView.tableHeaderView = userNib.instantiate(withOwner: self, options: [:]).first as? UIView
        } else {
            let abrNib = UINib(nibName: "ABRProfileHeader", bundle: Bundle.init(for: ABRProfileHeader.self))
            tableView.tableHeaderView = abrNib.instantiate(withOwner: self, options: [:]).first as? UIView
        }
    }

    
    func getUser() {
        ABRPlayer.get { (success, player, errorType) in
            if success {
                
            }
        }
    }
    
  
    //MARK: Table View DataSource
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ABRAppConfig.playerIncludes?.count ?? 0
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileRow", for: indexPath) as! ABRProfileRowCell
        cell.selectionStyle = .none
        let info = ABRAppConfig.playerIncludes?[indexPath.row]
        cell.titleLabel.text = info?.rawValue
        cell.valueTextField.text = ABRPlayer.current()?.passProperty(key: info!)
        cell.valueTextField.returnKeyType = .done
        cell.valueTextField.delegate = self
        
        
        if ((tableView.tableHeaderView as! ABRProfileHeader).editButton as! ABRSwitchableButton).isOn {
            cell.valueTextField.isUserInteractionEnabled = true
        } else {
            cell.valueTextField.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    //MARK: Table View Delegate
    
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let header = tableView.tableHeaderView as? ABRProfileHeader
        header?.headerHeightConstraint.constant = scrollView.contentOffset.y < 0 ?  -scrollView.contentOffset.y + 200 : 200
    }
    
    
    //MARK: Text Field Delegate

    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
