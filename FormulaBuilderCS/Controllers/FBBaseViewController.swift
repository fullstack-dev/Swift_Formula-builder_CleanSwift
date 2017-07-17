//
//  FBBaseViewController.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/7/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
import FormulaBuilderCore

//let window = UIApplication.shared.keyWindow!

class FBBaseViewController: UIViewController {
    // MARK: Properties

    fileprivate var line: UIView!
    fileprivate var cover: UIView!
    fileprivate var menuView: UIView!

    let viewMaxX: CGFloat = 300
    
    fileprivate var landscape = false
    fileprivate var isMenuViewHidden = true

    fileprivate var viewController: UIViewController!
    fileprivate var homeViewController: FBHomeViewController!
    fileprivate var homeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // show status bar when in landscape mode
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        view.endEditing(true)
        
        coordinator.animate(alongsideTransition: { context in
            // menu view is showing
            if self.menuView.frame.origin.x != kMenuViewInitialX {
                
                var viewFrame = self.navigationControllerView().frame
                viewFrame.origin.x = self.viewMaxX
                self.navigationControllerView().frame = viewFrame
                
                var menuViewFrame = self.menuView.frame
                menuViewFrame.size.width = viewFrame.origin.x + 1
                self.menuView.frame = menuViewFrame
            }
            
            if UIDevice.current.orientation.isLandscape { // landscape mode
                self.landscape = true
            } else { // portrait mode
                self.landscape = false
            }
        }, completion: nil)
    }
    
    fileprivate func configure() {
        
        addMenuView()
        addCoverOnTop()
    }
    
    // add a view on top of all subviews, if menu view is hidden, cover is hidden, if menu view is showing, cover is showing, so user can not touch any views below cover view
    fileprivate func addCoverOnTop() {
        cover = UIView(frame: view.bounds)
        cover.isHidden = true
        cover.superview?.bringSubview(toFront: cover)
        view.addSubview(cover)
    }
    
    fileprivate func addShadowEffect(to view: UIView) {
        view.layer.shadowOffset  = CGSize(width: CGFloat(3), height: 0)
        view.layer.shadowRadius  = 5
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
    }
    
    @IBAction func menuButtonClicked(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        if navigationControllerView().frame.origin.x != 0 {
            backToOriginalPosition(true)
        } else {
            backToOriginalPosition(false)
        }
    }
    
    // MARK: Touchs Event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var menuViewFrame = menuView.frame
        menuViewFrame.size.width = UIScreen.main.bounds.size.width - kMenuViewInitialX
        menuView.frame = menuViewFrame
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let currentLocation = touch.location(in: view)
            let previousLocation = touch.previousLocation(in: view)

            let xDifferent = currentLocation.x - previousLocation.x
            swipingView(xDifferent)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isMenuViewHidden && navigationControllerView().frame.origin.x > triggerViewX {
            backToOriginalPosition(false)
        } else {
            backToOriginalPosition(true)
        }
    }

    // swipe view right or left to show or hide menu view
    private func swipingView(_ xDifferent: CGFloat) {
        
        var viewFrame = navigationControllerView().frame
        let viewX = viewFrame.origin.x + xDifferent
        viewFrame.origin.x = viewX > 0 ? viewX : 0
        navigationControllerView().frame = viewFrame

        var menuViewFrame = menuView.frame
        let menuViewX = menuViewFrame.origin.x + xDifferent / 3
        menuViewFrame.origin.x = menuViewX > 0 ? 0 : menuViewX
        menuView.frame = menuViewFrame
        
        var lineFrame = line.frame
        lineFrame.origin.x = viewFrame.origin.x
        line.frame = lineFrame
        
        let alpha = (viewFrame.origin.x / viewMaxX / 2) + kMinAlpha
        menuView.alpha = alpha
    }

    fileprivate func addMenuView() {
        
        for view in window.subviews {
            if view.tag == kMenuViewTag {
                menuView = view
            }
            if view.tag == kLineTag {
                line = view
            }

            if line != nil && menuView != nil {
                return
            }
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "FBMenuViewController")
        menuView = menuViewController.view
        
        window.addSubview(menuView)
        menuViewController.view.frame = window.bounds
        
        var menuViewFrame = menuView.frame
        menuViewFrame.origin.x = kMenuViewInitialX
        menuView.frame = menuViewFrame
        
        addChildViewController(menuViewController)
        menuViewController.didMove(toParentViewController: self)
        
        // this line is between menu view and view, gives shadow effect
        line = UIView(frame: CGRect(x:-1, y:0, width:1, height:window.frame.size.height))
        line.tag = kLineTag
        line.backgroundColor = UIColor.lightGray
        window.addSubview(line)
        addShadowEffect(to: line)

        homeViewController = storyboard.instantiateViewController(withIdentifier: "FBHomeViewController") as! FBHomeViewController
        self.viewController = homeViewController
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.view.tag = homeViewController.view.tag

        window.addSubview(navigationController.view)
        navigationController.view.frame = window.bounds
        
        addChildViewController(navigationController)
        navigationController.didMove(toParentViewController: self)

        FBHelper.cacheTag(homeViewController.view.tag)
        self.homeView = navigationController.view
        
        window.bringSubview(toFront: line)
        
    }
    
    func willEnterForeground() {
        backToOriginalPosition(true)
    }
    
    private func backToOriginalPosition(_ yes: Bool) {
        var menuViewAlpha = kMinAlpha
        var menuViewFrame = menuView.frame
        var viewFrame = navigationControllerView().frame
        var lineFrame = line.frame

        isMenuViewHidden = yes
        
        if yes {
            viewFrame.origin.x = 0
            menuViewFrame.origin.x = kMenuViewInitialX
            menuViewFrame.size.width = view.frame.size.width - kMenuViewInitialX
            cover.isHidden = true
        } else {
            viewFrame.origin.x = viewMaxX
            menuViewFrame.origin.x = 0
            menuViewFrame.size.width = viewMaxX + lineFrame.size.width
            menuViewAlpha = 1
            cover.isHidden = false
        }

        lineFrame.origin.x = viewFrame.origin.x - 1
        
        UIView.animate(withDuration: kDuration, animations: {
            self.menuView.frame = menuViewFrame
            self.navigationControllerView().frame = viewFrame
            self.line.frame = lineFrame
            
            self.menuView.alpha = menuViewAlpha
        })
    }
    
    public func addViewControllerOnTop(_ viewController: UIViewController) {
        back {

            if viewController.view.tag == FBHelper.getTag() {
                return
            }
            
            if viewController.view.tag == kHomeViewTag {
                for view in window.subviews {
                    if view.tag == FBHelper.getTag() {
                        view.removeFromSuperview()
                    }
                }
                
                FBHelper.cacheTag(self.homeView.tag)
                
                window.bringSubview(toFront: self.homeView)
                window.bringSubview(toFront: self.line)
                
                
                return
            }
            
            self.viewController = viewController
            
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.view.tag = viewController.view.tag

            window.addSubview(navigationController.view)
            navigationController.view.frame = window.bounds
            
            self.addChildViewController(navigationController)
            navigationController.didMove(toParentViewController: self)
            
            for view in window.subviews {
                if view.tag == FBHelper.getTag() {
                    if view.tag == kHomeViewTag {
                        window.sendSubview(toBack: view)
                    } else {
                        view.removeFromSuperview()
                    }
                } else if view.tag == kLineTag {
                    window.bringSubview(toFront: view)
                }
            }
            
            FBHelper.cacheTag(viewController.view.tag)
        }
    }
    
    func back(completion: @escaping () -> Swift.Void) {
        
        var menuViewFrame = menuView.frame
        var viewFrame = navigationControllerView().frame
        var lineFrame = line.frame

        isMenuViewHidden = true

        viewFrame.origin.x = 0
        menuViewFrame.origin.x = kMenuViewInitialX
        menuViewFrame.size.width = view.frame.size.width - kMenuViewInitialX
        cover.isHidden = true

        lineFrame.origin.x = viewFrame.origin.x
        
        UIView.animate(withDuration: kDuration, animations: {
            self.menuView.frame = menuViewFrame
            self.navigationControllerView().frame = viewFrame
            self.line.frame = lineFrame
            
            self.menuView.alpha = kMinAlpha
        }) { finished in
            completion()
        }
    }
    
    func navigationControllerView() -> UIView {
        for view in window.subviews {
            if view.tag == FBHelper.getTag() {
                return view
            }
        }
        return UIView()
    }
}
