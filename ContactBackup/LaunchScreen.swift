//
//  LaunchScreen.swift
//  ContactBackup
//
//

import UIKit

class LaunchScreen: BaseViewController , UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    let pageTitles = ["Title 1", "Title 2"]
    var images = ["welcome1.png","welcome2.png"]
    var count = 0
    
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        reset()
        
    }
   /* 
    @IBAction func swipeLeft(sender: AnyObject)
    {
        print("SWipe left")
    }
    @IBAction func swiped(sender: AnyObject)
    {
        
        self.pageViewController.view .removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        reset()
    }
     */
    
    func reset()
    {
        /* Getting the page View controller */
        
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.pageViewController.view.backgroundColor = Util_Color.GetBlueolor()
              
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        self.pageViewController.didMove(toParentViewController: self)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageContentViewController).pageIndex!
        
        if(index <= 0)
        {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageContentViewController).pageIndex!
        index += 1
        
        if(index  >= self.images.count)
        {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(_ index : Int) -> UIViewController?
    {
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count))
        {
            return nil
        }
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        pageContentViewController.imageName = self.images[index]
        pageContentViewController.titleText = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}
