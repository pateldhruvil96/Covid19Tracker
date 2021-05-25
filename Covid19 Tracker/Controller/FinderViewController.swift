//
//  FinderViewController.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Patel on 5/22/21.
//

import UIKit

class FinderViewController: BaseViewController, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptySearchImageView: UIImageView!
    
    let seachController  = UISearchController()
    var currentAPITask: URLSessionDataTask?
    var countryNameList = [String]()
    var countryNameListCompact = [String]()
    var countryCodeList = [String]()
    var countryCodeListCompact = [String]()
    var numberOfCountries:Int = 10
    var lastText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        //If wanted to delete data from CoreData & UserDefaults uncomment below code
        //removeAllSavedData()
    }
    func setup(){
        seachController.searchBar.delegate = self
        navigationItem.searchController = seachController
        seachController.obscuresBackgroundDuringPresentation = false;
        
        let nibCustomTableViewCell = UINib(nibName: COUNTRYLISTCELL, bundle: nil)
        tableView.register(nibCustomTableViewCell, forCellReuseIdentifier: COUNTRYLISTCELL)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if Reachability.isConnectedToNetwork(){
            lastText = searchText
            self.currentAPITask?.cancel()
            callAPI()
        }else{
            alert(title: "Oops", message: "Not connected with internet")
        }
        
    }
    func removeAllSavedData(){
        deleteAllRecords(entityName: "ImageSave")
        deleteAllRecords(entityName: "SelectedCountry")
        resetDefaults()
    }

    func callAPI(){
        guard let url = URL(string: BASEURL + EndPoints.summary.rawValue) else {
            return
        }
        if lastText.isEmpty{
            currentAPITask?.cancel()
            countryNameList.removeAll()
            countryCodeList.removeAll()
            countryNameListCompact.removeAll()
            countryCodeListCompact.removeAll()
            self.tableView.reloadData()
        }else{
            self.currentAPITask = APIConnection.shared.makeRequest(toURL: url , params: ["":""], method: .Get) { [weak self] (error, data) in
                if let err = error {
                    //Show error
                    print("got error \(err)")
                    let alertController = self?.genericRetryAlert(retry:  { (action) in
                        self?.callAPI()
                    })
                    self?.present(alertController ?? UIAlertController(), animated: true, completion: nil)
                    return
                }
                
                guard let responseData = data else {
                    let alertController = self?.genericRetryAlert(retry:  { (action) in
                        self?.callAPI()
                    })
                    self?.present(alertController ?? UIAlertController(), animated: true, completion: nil)
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                let responseModel = try? jsonDecoder.decode(Summary.self, from: responseData)
                if let resp = responseModel {
                    let items = resp.countries
                        let filter = items.filter { countryList in
                            return (countryList.country.contains(self!.lastText))
                        }
                        self?.countryNameList = filter.map({ countryList in
                            return countryList.country
                        })
                        self?.countryCodeList = filter.map({ countryList in
                            return countryList.countryCode
                        })
                        self?.countryNameListCompact = (self?.countryNameList.enumerated().filter { $0.offset < (self!.numberOfCountries) }.map { $0.element })!
                        self?.countryCodeListCompact = (self?.countryCodeList.enumerated().filter { $0.offset < (self!.numberOfCountries) }.map { $0.element })!

                        self?.tableView.reloadData()
                    
                }
            }
        }
    }

}
extension FinderViewController:UIScrollViewDelegate{
    
    //Pagination:
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.height
        if bottomEdge >= scrollView.contentSize.height{ //Reached bottom
            numberOfCountries += 10
            if !lastText.isEmpty && numberOfCountries < countryNameList.count{
                
                //to make subarray of "countryNameListCompact" consisting of element from (0 to numberOfCountries) index
                countryNameListCompact = countryNameList.enumerated().filter { $0.offset < numberOfCountries }.map { $0.element }
                countryCodeListCompact = countryCodeList.enumerated().filter { $0.offset < numberOfCountries }.map { $0.element }
                
            }else{
                
                countryNameListCompact = countryNameList.enumerated().filter { $0.offset < countryNameList.count }.map { $0.element }
                countryCodeListCompact = countryCodeList.enumerated().filter { $0.offset < countryCodeList.count }.map { $0.element }
                
            }
            tableView.reloadData()
        }
    }
}
extension FinderViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVC = self.storyboard!.instantiateViewController(withIdentifier: "SelectedCountryViewController") as! SelectedCountryViewController
        selectedVC.selectedCountryName = countryNameListCompact[indexPath.row]
        selectedVC.countryCodeName = countryCodeListCompact[indexPath.row]
        present(selectedVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? IPADTABLECELLHEIGHT : IPHONETABLECELLHEIGHT
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptySearchImageView.isHidden = countryNameListCompact.isEmpty ? false : true
        return countryNameListCompact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListsTableViewCell", for: indexPath) as! CountryListsTableViewCell
        cell.countryNameLabel.text = countryNameListCompact[indexPath.row]
        let countryCode = countryCodeListCompact[indexPath.row]
        let urlString = FLAGURL + countryCode + EndPoints.flagImage.rawValue
        cell.configureWith(urlString: urlString, saveAsCache: true)
        return cell
    }
}
