//
//  SelectedCountryViewController.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 23/05/21.
//

import UIKit
import CoreData

class SelectedCountryViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    private var datasource: [DatasourceType] = []
    
    var selectedCountryName:String?
    var countryCodeName:String?
    
    var showWorldStats = Bool()
    
    var currentAPITask: URLSessionDataTask?
    
    var items:CountryDetails!
    var pastWeekItems = [CountryDetails]()
    var countryDetailModel:[SelectedCountry] = []
    
    var isSaved = Bool()
    var cameFromSavedVC = Bool()
    
    var savedCountries = [String]()
    
    var flagImage:UIImage?
    
    private let sectionInset: UIEdgeInsets = .init(top: 24, left: 10, bottom: 10, right: 10)
    private let lineSpacing: CGFloat = 16
    private let interItemSpacing: CGFloat = 16
    
    enum DatasourceType {
        case totalCases(Timeline)
        case percentRate(type: PercentRateCell.Status, percent: Double)
        case spreadOverTime([CountryDetails])
        //        case todayCases(Country)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !showWorldStats{
            titleLabel.text = selectedCountryName
            if cameFromSavedVC{
                fetchFromDB()
                saveButtonOutlet.isHidden = true
                flagImageView.image = flagImage
            }else{
                callAPI()
                let urlString = FLAGURL + (countryCodeName ?? "") + "/shiny/64.png"
                flagImageView.downloadImage(from: urlString, saveAsCache: false)
                savedCountries = UserDefaults.standard.object(forKey: "savedCountries") as? [String] ?? []
                saveButtonOutlet.tintColor = .white
                saveButtonOutlet.setImage(UIImage.init(systemName: "bookmark"), for:.normal)
                saveButtonOutlet.setImage(UIImage.init(systemName: "bookmark.fill"), for:.highlighted)
            }
        }else{
            if !Reachability.isConnectedToNetwork(){
                alert(title: "Oops", message: "Not connected with internet")
            }else{
                callWorldStatsAPI()
                titleLabel.text = "World"
                backButtonOutlet.isHidden = true
                saveButtonOutlet.isHidden = true
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !cameFromSavedVC && !showWorldStats{
            UserDefaults.standard.set(savedCountries, forKey: "savedCountries")
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyGradient(colors: [UIColor(hexCode: "5C43F5").cgColor,UIColor(hexCode: "4D8DFF").cgColor], locations: nil, direction: .topToBottom)
        
    }
    func callAPI(){
        let stringUrl = COUNTRYDETAILURL + (selectedCountryName ?? "")
        
        guard let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return
        }
        LoadingOverlay.shared.showOverlay(view: view)
        self.currentAPITask = APIConnection.shared.makeRequest(toURL: url , params: ["":""], method: .Get) { [weak self] (error, data) in
            LoadingOverlay.shared.hideOverlayView()
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
            let responseModel = try? jsonDecoder.decode(CountryDetail.self, from: responseData)
            if let resp = responseModel {
                let items = resp.last!
                self?.items = items
                if !(self!.savedCountries.isEmpty) && self!.savedCountries.contains(self!.items.country){
                    self?.isSaved = true
                    self?.saveButtonOutlet.setImage(UIImage.init(systemName: "bookmark.fill"), for:.normal)
                }
                self?.pastWeekItems = Array(resp.suffix(7))
                self?.datasource = [
                    .spreadOverTime(self!.pastWeekItems),
                    .percentRate(
                        type: .recovery,
                        percent: items.recovered == 0 ? 1 : Double(items.recovered) / Double(items.timeline.cases)
                    ),
                    .percentRate(
                        type: .fatality,
                        percent:  Double(items.deaths) / Double(items.timeline.cases)
                    ),
                    .totalCases(
                        items.timeline
                    )
                    
                ]
                self?.collectionView.reloadData()
            }
        }
    }
    func callWorldStatsAPI(){
        guard let url = URL(string: BASEURL + EndPoints.summary.rawValue) else {return}
        LoadingOverlay.shared.showOverlay(view: view)
        self.currentAPITask = APIConnection.shared.makeRequest(toURL: url , params: ["":""], method: .Get) { [weak self] (error, data) in
            LoadingOverlay.shared.hideOverlayView()
            if let err = error {
                //Show error
                print("got error \(err)")
                let alertController = self?.genericRetryAlert(retry:  { (action) in
                    self?.callWorldStatsAPI()
                })
                self?.present(alertController ?? UIAlertController(), animated: true, completion: nil)
                return
            }
            
            guard let responseData = data else {
                let alertController = self?.genericRetryAlert(retry:  { (action) in
                    self?.callWorldStatsAPI()
                })
                self?.present(alertController ?? UIAlertController(), animated: true, completion: nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let responseModel = try? jsonDecoder.decode(Summary.self, from: responseData)
            if let resp = responseModel {
                let items = resp.global
                let totalActive = Double(items.totalConfirmed) - (Double(items.totalDeaths) + Double(items.totalRecovered))
                self?.datasource = [
                    .percentRate(type: .recovery, percent: Double(items.totalRecovered) / Double(items.totalConfirmed)),
                    .percentRate(type: .fatality, percent: Double(items.totalDeaths) / Double(items.totalConfirmed)),
                    .totalCases(Timeline(cases: Int(items.totalConfirmed), active: Int(totalActive), deaths: Int(items.totalDeaths), recovered: Int(items.totalRecovered)))
                ]
                self?.collectionView.reloadData()
                
            }
        }
    }
    func fetchFromDB(){
        do{
            let countryDetials = try context.fetch(SelectedCountry.fetchRequest())
            countryDetailModel = countryDetials  as! [SelectedCountry]
            let items = countryDetailModel.last!
            self.datasource = [
                .percentRate(type: .recovery, percent: items.recovered == 0 ? 1 : Double(items.recovered) / Double(items.confirmed)),
                .percentRate(type: .fatality, percent: Double(items.deaths) / Double(items.confirmed)),
                .totalCases(Timeline(cases: Int(items.confirmed), active: Int(items.active), deaths: Int(items.deaths), recovered: Int(items.recovered)))
                
            ]
            self.collectionView.reloadData()
            
        }catch{
            print(error)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if isSaved{
            //Removing from CoreData
            savedCountries = savedCountries.filter({$0 != items.country})
            isSaved = false
            saveButtonOutlet.setImage(UIImage.init(systemName: "bookmark"), for:.normal)
            do{
                var coreDataIndex = 0
                let countryDetials = try context.fetch(SelectedCountry.fetchRequest())
                countryDetailModel = countryDetials  as! [SelectedCountry]
                for (index,element) in countryDetailModel.enumerated(){
                    if(element.country == items.country){
                        coreDataIndex = index
                        break
                    }
                }
                let managedObjectData:NSManagedObject = countryDetials[coreDataIndex] as! NSManagedObject
                context.delete(managedObjectData)
                try context.save()
            }catch{
                print(error)
            }
            
        }else{
            //Saving to CoreData
            savedCountries.append(items.country)
            isSaved = true
            saveButtonOutlet.setImage(UIImage.init(systemName: "bookmark.fill"), for:.normal)
            
            let countryDetails  = SelectedCountry(context: context)
            
            countryDetails.active = Int64(items.active)
            countryDetails.city = items.city
            countryDetails.cityCode = items.cityCode
            countryDetails.confirmed = Int64(items.confirmed)
            countryDetails.country = items.country
            countryDetails.countryCode = countryCodeName ?? ""
            countryDetails.date = items.date
            countryDetails.deaths = Int64(items.deaths)
            countryDetails.lat = items.lat
            countryDetails.lon = items.lon
            countryDetails.province = items.province
            countryDetails.recovered = Int64(items.recovered)
            
            if let imageData = flagImageView.image?.pngData(){
                let saveImage  = ImageSave(context: context)
                saveImage.image = imageData
            }
            do{
                try context.save()
            }catch{
                print(error)
            }
            
        }
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func registerCells() {
        
        // Note: TotalCasesCollectionViewCell created from xib, rest are from code
        
        let nibImageCollectionViewCell = UINib(nibName: TOTALCASESCELL, bundle: nil)
        collectionView.register(nibImageCollectionViewCell, forCellWithReuseIdentifier: TOTALCASESCELL)
        
        collectionView.register(SpreadOverTimeCell.self)
        collectionView.register(PercentRateCell.self)
    }
    
}
extension SelectedCountryViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = datasource[indexPath.row]
        switch item {
        case .totalCases(let country):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TOTALCASESCELL, for: indexPath) as! TotalCasesCollectionViewCell
            cell.setup(timeline: country)
            return cell
        case .spreadOverTime(let historicalTimelineList):
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SpreadOverTimeCell
            cell.setup(historicalTimelineList: historicalTimelineList)
            return cell
        case .percentRate(type: let type, percent: let percent):
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PercentRateCell
            cell.setup(type: type, percent: percent)
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    
}
extension SelectedCountryViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if !datasource.isEmpty{
            let item = datasource[indexPath.item]
            
            switch item {
            case .totalCases:
                let width: CGFloat = collectionView.frame.width - sectionInset.left - sectionInset.right
                return .init(width: width, height: 319)
            case .percentRate:
                let sectionWidth: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
                let width = (sectionWidth / 2) - (interItemSpacing / 2)
                return .init(width: width, height: PercentRateCell.height)
            case .spreadOverTime:
                let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
                return .init(width: width, height: SpreadOverTimeCell.height)
            }
        }else{
            return CGSize.zero
        }
    }
}
