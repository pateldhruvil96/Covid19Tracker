//
//  TabBarViewController.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 24/05/21.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        tabBarDesign()
        
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: FINDERVC) as! FinderViewController
        let homeVCNavigationController = UINavigationController(rootViewController: homeVC)
        homeVCNavigationController.navigationBar.topItem?.title = "Covid Tracker"
        homeVCNavigationController.navigationBar.prefersLargeTitles = true
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tabbar_search"), tag: 0)
        
        let worldVC = self.storyboard!.instantiateViewController(withIdentifier: SELECTEDVC) as! SelectedCountryViewController
        worldVC.showWorldStats = true
        worldVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tabbar_world"), tag: 1)
        
        let savedVC = self.storyboard!.instantiateViewController(withIdentifier: SAVEDVC) as! SavedViewController
        let savedVCNavigationController = UINavigationController(rootViewController: savedVC)
        savedVCNavigationController.navigationBar.topItem?.title = "Saved Countries"
        savedVCNavigationController.navigationBar.prefersLargeTitles = true
        savedVC.tabBarItem = UITabBarItem(title: "", image: UIImage.init(systemName: "bookmark"), tag: 2)
        
        viewControllers = [homeVCNavigationController, worldVC, savedVCNavigationController]
        
    }
    func tabBarDesign(){
        tabBar.isOpaque = true
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = UIColor.white
        
        tabBar.layer.cornerRadius = 20
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.2
    }
    
}
