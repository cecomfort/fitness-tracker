//
//  RunPageVCViewController.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/21/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

import UIKit

class RunPageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: Properties
    var pageControl = UIPageControl()
    var runSummaryVC : RunSummaryVC?
    var runSplitsVC : RunSplitsVC?
    var runVCs : [UIViewController] = []
    var run : Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        createViewControllers()
        setUpFirstController()
        configurePageControl()
    }
    
    // MARK: Configuring VCs and Page Control
    func createViewControllers() {
        runSummaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "runSummary") as? RunSummaryVC
        runSplitsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "splits") as? RunSplitsVC
        
        // Send data from parent PageViewController to child VCs
        if let firstVC = runSummaryVC, let secondVC = runSplitsVC, let runInfo = run {
            firstVC.run = runInfo
            secondVC.splits = runInfo.splits()
            print("Splits: \(runInfo.splits())")
            runVCs = [firstVC, secondVC]
        }
    }
    
    func setUpFirstController() {
        if let firstVC = runVCs.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func configurePageControl() {
        // Alter y to change the height
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: 50))
        self.pageControl.numberOfPages = runVCs.count
        //        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.gray
        self.view.addSubview(pageControl)
    }
    
    
    // MARK: Delegate methods
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let nextVC = pageViewController.viewControllers?[0] {
            self.pageControl.currentPage = runVCs.index(of: nextVC)!
        }
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = runVCs.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = currentIndex - 1
        // Allow swiping to the left from first VC
        guard previousIndex >= 0 else {
            return runVCs.last
            
        }
        //need?
        guard runVCs.count > previousIndex else {
            return nil
        }
        return runVCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = runVCs.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        // Allow swiping to the right from lastVC
        guard runVCs.count != nextIndex else {
            return runVCs.first
        }
        
        // need?
        guard runVCs.count > nextIndex else {
            return nil
        }
        return runVCs[nextIndex]
    }
}
