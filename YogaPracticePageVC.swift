//
//  YogaPracticePageVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/20/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

// TODO: Any way to ensure saving?, when save tranistion to first page


class YogaPracticePageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // MARK: Properties
    var pageControl = UIPageControl()
    var page1VC : YogaDetailsTVC?
    var page2VC : YogaNotesTVC?
    var yogaVCs : [UIViewController] = []
    var store = DataStore.sharedInstance
    var yogaPractice : YogaPractice?
    var practiceIndex : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        updateNavTitle()
        
        createViewControllers()
        setUpFirstController()
        configurePageControl()
    }
    
    func updateNavTitle() {
        if yogaPractice != nil {
            title = "Practice Summary"
        }
    }
    
    @IBAction func saveYogaPractice(_ sender: Any) {
        print("Saving!")

        let date = page1VC?.datePicker.date
        let style = page1VC?.style.text
        let duration = page1VC?.duration.text
        let location = page1VC?.location.text
        let instructor = page1VC?.instructor.text
        let focus = page1VC?.focus.text
        
        let notes : String
        let cardioLevel : Int
        let strengthBuildingLevel : Int
        let flexibilityLevel : Int
        
        
        if let page2VC = page2VC, page2VC.notesPageVisited {
            notes = page2VC.notesTextField.text
            cardioLevel = page2VC.cardioLevel.rating
            strengthBuildingLevel = page2VC.strengthBuildingLevel.rating
            flexibilityLevel = page2VC.flexibilityLevel.rating
        } else {
            cardioLevel = 0
            strengthBuildingLevel = 0
            flexibilityLevel = 0
            notes = ""
        }
        
        
        if date == nil || style == "" || duration == "" {
            createAlert(title: "Unable to Save Practice", message: "Date, style, and duration fields must be complete.")
        } else if duration == "0:00" {
            createAlert(title: "Unable to Save Practice", message: "Duration must be greater than 0.")
        } else if date! > Date() {
            createAlert(title: "Unable to Save Practice", message: "Date must be in the past")
        } else if let newPractice = YogaPractice(date: date!, style: style!, duration: duration!, instructor: instructor, location: location, focus: focus, notes: notes, cardioLevel: cardioLevel, strengthBuildingLevel: strengthBuildingLevel, flexibilityLevel: flexibilityLevel) {
            if let index = practiceIndex {
                // Edit existing practice
                store.editPractice(item: newPractice, index: index)
            } else {
                // Create new practice
                store.addPractice(item: newPractice)
            }
            clearTextFields()
        }
    }
    
    func clearTextFields() {
        page1VC?.resetFeilds()
        if let page2VC = page2VC, page2VC.notesPageVisited {
            page2VC.resetFields()
        }
    }
    
    // MARK: Configuring VCs and Page Control
    func createViewControllers() {
        page1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PracticeDetailsPage1") as? YogaDetailsTVC
       page2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PracticeDetailsPage2") as? YogaNotesTVC
        
        if let firstVC = page1VC, let secondVC = page2VC {
            yogaVCs = [firstVC, secondVC]
            
            // Send data from parent PageViewController to child VCs
            if let savedPractice = yogaPractice {
                firstVC.yogaPractice = savedPractice
                secondVC.yogaPractice = savedPractice
            }
        }
    }
    
    func setUpFirstController() {
        if let firstVC = yogaVCs.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func configurePageControl() {
        // Alter y to change the height
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: 50))
        self.pageControl.numberOfPages = yogaVCs.count
        //        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.gray
        self.view.addSubview(pageControl)
    }
    
    
    // MARK: Delegate methods
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let nextVC = pageViewController.viewControllers?[0] {
            self.pageControl.currentPage = yogaVCs.index(of: nextVC)!
        }
    }
    
    // Prepare for swipe segues, allowing data to pass between child VCs
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = yogaVCs.index(of: viewController) else {
            return nil
        }
        let previousIndex = currentIndex - 1
        // Allow swiping to the left from first VC
        guard previousIndex >= 0 else {
            return yogaVCs.last
        }
        return yogaVCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = yogaVCs.index(of: viewController) else {
            return nil
        }
        let nextIndex = currentIndex + 1
        // Allow swiping to the right from last VC
        guard yogaVCs.count != nextIndex else {
            return yogaVCs.first
        }
        return yogaVCs[nextIndex]
    }
    
    func createAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
