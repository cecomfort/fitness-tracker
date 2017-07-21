//
//  YogaPracticePageVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/20/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

// TODO: Anyway to ensure saving?
// TODO: Add location to yoga model
// TODO: Loop to reset fields?

class YogaPracticePageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // MARK: Properties
    var pageControl = UIPageControl()
    var page1VC : YogaDetailsTVC?
    var page2VC : YogaNotesTVC?
    var yogaVCs : [UIViewController] = []
    var store = DataStore.sharedInstance
    var date: Date?
    var cardioLevel = 0
    var strengthBuildingLevel = 0
    var flexibilityLevel = 0
    var yogaPractice : YogaPractice?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        createViewControllers()
        setUpFirstController()
        configurePageControl()
    }
    
    @IBAction func saveYogaPractice(_ sender: Any) {
        print("Saving!")
//        let data = page1VC?.duration.text
//        print(data)
        
        let style = page1VC?.style.text
        let duration = page1VC?.duration.text
        let location = page1VC?.location.text
        let instructor = page1VC?.instructor.text
        let focus = page1VC?.focus.text
        let notes = page2VC?.notesTextField.text
        
        // Date may be nil, so check that first
        if let dateInput = date, let newPractice = YogaPractice(date: dateInput, style: style!, duration: duration!, instructor: instructor, focus: focus, notes: notes, cardioLevel: cardioLevel, strengthBuildingLevel: strengthBuildingLevel, flexibilityLevel: flexibilityLevel) {
            print("Trying to save!")
            store.addPractice(item: newPractice)
            clearTextFields()
        }
    }
    
    // Better way to do this? loop?
    func clearTextFields() {
        page1VC?.style.text = ""
        page1VC?.duration.text = ""
        page1VC?.location.text = ""
        page1VC?.instructor.text = ""
        page1VC?.focus.text = ""
        page2VC?.notesTextField.text = ""
        page2VC?.cardioLevel.rating = 0
        page2VC?.strengthBuildingLevel.rating = 0
        page2VC?.flexibilityLevel.rating = 0
        
        date = nil
        cardioLevel = 0
        strengthBuildingLevel = 0
        flexibilityLevel = 0
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
        if let dateInput = page1VC?.datePicker.date {
            date = dateInput
            print("date: \(dateInput)")
        }
        if let cardioInput = page2VC?.cardioLevel.rating {
            cardioLevel = cardioInput
            print("cardio level: \(cardioLevel)")
        }
            if let strengthBuildingInput = page2VC?.strengthBuildingLevel.rating {
                strengthBuildingLevel = strengthBuildingInput
                print("strengthBuildingLevel: \(strengthBuildingLevel)")
            }
            
            if let flexibilityInput = page2VC?.flexibilityLevel.rating {
                flexibilityLevel = flexibilityInput
                print("flexibilityLevel: \(flexibilityLevel)")
            }
//        }
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
}
