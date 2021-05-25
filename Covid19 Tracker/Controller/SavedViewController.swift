//
//  SavedViewController.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Patel on 5/22/21.
//

import UIKit

class SavedViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var countryDetials = [SelectedCountry]()
    
    var imageDetails:[ImageSave] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCustomTableViewCell = UINib(nibName: COUNTRYLISTCELL, bundle: nil)
        tableView.register(nibCustomTableViewCell, forCellReuseIdentifier: COUNTRYLISTCELL)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDatafromDB()
    }
    func loadDatafromDB(){
        do{
            countryDetials = try context.fetch(SelectedCountry.fetchRequest())
            let imageData = try context.fetch(ImageSave.fetchRequest())
            imageDetails = imageData as! [ImageSave]
            self.tableView.reloadData()
            
        }catch{
            print(error)
        }        
        if countryDetials.isEmpty{
            alert(title: "Oops", message: "No saved countries found.Try saving some and come back")
        }
    }
    
}
extension SavedViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVC = self.storyboard!.instantiateViewController(withIdentifier: "SelectedCountryViewController") as! SelectedCountryViewController
        selectedVC.selectedCountryName = countryDetials[indexPath.row].country
        selectedVC.countryCodeName = countryDetials[indexPath.row].countryCode
        selectedVC.cameFromSavedVC = true
        selectedVC.flagImage = UIImage(data: (imageDetails[indexPath.row].image))
        present(selectedVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? IPADTABLECELLHEIGHT : IPHONETABLECELLHEIGHT
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryDetials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListsTableViewCell", for: indexPath) as! CountryListsTableViewCell
        cell.countryNameLabel.text = countryDetials[indexPath.row].country
        cell.countryFlagImageView.image = UIImage(data: (imageDetails[indexPath.row].image))
        return cell
    }
}
