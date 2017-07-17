    //
    //  FBMenuViewController.swift
    //  FormulaBuilderCS
    //
    //  Created by PFIdev on 2/3/17.
    //  Copyright (c) 2017 orgname. All rights reserved.
    //
    //  This file was generated by the Clean Swift Xcode Templates so you can apply
    //  clean architecture to your iOS and Mac projects, see http://clean-swift.com
    //

import UIKit
import PKHUD
import FormulaBuilderCore
    
let kMenuViewInitialX: CGFloat = -100
let window = UIApplication.shared.keyWindow!

protocol FBMenuViewControllerInput {
    func displaySomething(viewModel: FBMenu.Something.ViewModel)
}

protocol FBMenuViewControllerOutput {
    func doSomething(request: FBMenu.Something.Request)
}

class FBMenuViewController: UIViewController, FBMenuViewControllerInput {
    var output: FBMenuViewControllerOutput!
    var router: FBMenuRouter!
    
    fileprivate var presentView: UIView?
    fileprivate var presentViewController: UIViewController!
    fileprivate var homeNavigationView: UIView!
    fileprivate var homeViewController: FBHomeViewController!
    fileprivate var isMenuViewHidden = true
    fileprivate var landscape = false
    fileprivate var cover: UIView!
    let controllerViewStopX: CGFloat = 300
    
    let cellTexts = [["Home"], ["Advanced Search"], ["Single Herbs", "Categories", "Add New Herbs"], ["Formulas", "Categories", "Add New Formula"], ["Favorites"], ["Recent Search"], ["Settings", "References"]]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var childControllerView: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var childControllerViewLeading: NSLayoutConstraint!
    @IBOutlet weak var menuViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var menuViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FBMenuConfigurator.sharedInstance.configure(viewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        addHomeView()
        addShadowEffect(to: line)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func configureTableView() {
        tableView.register(UINib(nibName: kMenuCell, bundle: nil), forCellReuseIdentifier: kMenuCell)
    }

    func doSomethingOnLoad() {

        let request = FBMenu.Something.Request()
        output.doSomething(request: request)
    }

    func displaySomething(viewModel: FBMenu.Something.ViewModel) {}
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            if UIDevice.current.orientation.isLandscape { // landscape mode
                self.headerHeight.constant = 33 // in landscape navigation bar height is 32
            } else {
                self.headerHeight.constant = 45
            }
        }, completion: nil)
    }
    
    fileprivate func addHomeView() {
        
        homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBHomeViewController") as! FBHomeViewController
        presentViewController = homeViewController
        addChildControllerView(homeViewController)
    }
    
    func addChildControllerView(_ viewController: UIViewController, withMenuButton: Bool = true) {
        
        if (withMenuButton) {
            let menuButton = UIButton.init(type: .custom)
            menuButton.frame = CGRect(x: 0, y: 0, width: 23, height: 13)
            menuButton.setImage(UIImage(named: "menu"), for: .normal)
            menuButton.tag = 3000
            menuButton.addTarget(self, action: #selector(menuButtonClicked(_:)), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: menuButton)
        } else {
            let cancelButton = UIButton.init(type: .custom)
            cancelButton.frame = CGRect(x: 0, y: 0, width: 60, height: 13)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(FBColor.hexColor_0076FF(), for: .normal)
            cancelButton.tag = 3000
            cancelButton.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: cancelButton)
        }
        
//        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuButtonClicked))
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setValue(FBNavigationBar(), forKey: "navigationBar")
        
        if viewController is FBHomeViewController {
            homeNavigationView = navigationController.view
        } else {
            presentView = navigationController.view
        }
        
        childControllerView.addSubview(navigationController.view)
        navigationController.view.frame = childControllerView.bounds
        
        addChildViewController(navigationController)
        navigationController.didMove(toParentViewController: self)
        
        addCoverOnTop()
    }
    
    fileprivate func addCoverOnTop() {
        var coverViewHeight = UIScreen.main.bounds.size.height
        if cover == nil {
            if (UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height)
            {
                coverViewHeight = UIScreen.main.bounds.size.width
            }
            cover = UIView(frame: CGRect(x: 0, y: 0, width: coverViewHeight, height: coverViewHeight))
            cover.isHidden = true
            cover.superview?.bringSubview(toFront: cover)
            childControllerView.addSubview(cover)
        } else {
            cover.superview?.bringSubview(toFront: cover)
        }
    }
    
    fileprivate func addShadowEffect(to view: UIView) {
        view.layer.shadowOffset  = CGSize(width: CGFloat(-3), height: 0)
        view.layer.shadowRadius  = 5
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
    }
    
    func willEnterForeground() {
        backToOriginalPosition(true)
    }
    
    @IBAction func menuButtonClicked(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        if childControllerViewLeading.constant != 0 {
            backToOriginalPosition(true, completion: nil)
        } else {
            backToOriginalPosition(false, completion: nil)
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        view.endEditing(true)
                
        addHomeView()
    }
    
    // MARK: Touchs Event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            if touch.view != homeViewController.output.formulaSearchViewController.header {
                
                if presentViewController.navigationController?.viewControllers.count == 1 {
                    let currentLocation = touch.location(in: view)
                    let previousLocation = touch.previousLocation(in: view)
                    let xDifferent = currentLocation.x - previousLocation.x
                    swipingView(xDifferent)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if isMenuViewHidden && childControllerViewLeading.constant > triggerViewX {
            backToOriginalPosition(false, completion: nil)
        } else {
            backToOriginalPosition(true, completion: nil)
        }
    }
    
    // swipe view right or left to show or hide menu view
    private func swipingView(_ xDifferent: CGFloat) {
        
        var constant = childControllerViewLeading.constant + xDifferent
        childControllerViewLeading.constant = constant > 0 ? constant : 0

        if childControllerViewLeading.constant >= controllerViewStopX {
            menuViewLeading.constant = 0
            menuViewWidth.constant = childControllerViewLeading.constant
        } else {
            menuViewWidth.constant = controllerViewStopX
            
            constant = menuViewLeading.constant + xDifferent / 3
            menuViewLeading.constant = constant > 0 ? 0 : constant
        }
        
        menuView.alpha = (childControllerViewLeading.constant / controllerViewStopX / 2) + kMinAlpha
    }
    
    func backToOriginalPosition(_ yes: Bool, completion: (() -> Swift.Void)? = nil) {
        var menuViewAlpha = kMinAlpha

        isMenuViewHidden = yes
        
        if yes {
            childControllerViewLeading.constant = 0
            menuViewLeading.constant = kMenuViewInitialX
            cover.isHidden = true
        } else {
            childControllerViewLeading.constant = controllerViewStopX
            menuViewLeading.constant = 0
            menuViewAlpha = 1
            cover.isHidden = false
        }
        
        menuViewWidth.constant = controllerViewStopX

        UIView.animate(withDuration: kDuration, animations: { 
            self.view.layoutIfNeeded()
            self.menuView.alpha = menuViewAlpha
            self.cover.backgroundColor = UIColor.white
            self.cover.alpha = kMinAlpha
        }) { finished in
            completion?()
        }
    }

    fileprivate func removePresentView() {
        presentView?.removeFromSuperview()
        presentView = nil
    }
}

extension FBMenuViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTexts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTexts[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: kMenuCell) as! FBMenuCell
        
        cell.configure(with: cellTexts[indexPath.section][indexPath.row])
        if (indexPath.section == 2 && indexPath.row == 0) || (indexPath.section == 3 && indexPath.row == 0)
        {
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 7 {
            return 0.01
        }
        
        return 10
    }

}
    
extension FBMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if (section == 3 && row == 0) || (section == 2 && row == 0)
        {
            return
        }
        backToOriginalPosition(true) {
            
            if section == 0 || section == 4 || section == 5 { // home or favorite
                self.removePresentView()
                
                self.presentViewController = self.homeViewController
                
                self.homeNavigationView.superview?.bringSubview(toFront: self.homeNavigationView)
                self.cover.superview?.bringSubview(toFront: self.cover)
                
                if section == 0 {
                    self.homeViewController.title = "Formula Builder"
                    self.homeViewController.changeFilter(.all)
                } else if section == 4 {
                    self.homeViewController.title = "Favorites"
                    self.homeViewController.changeFilter(.favorite)
                } else {
                    self.homeViewController.title = "Recent"
                }
                
                return
            } else if section == 1 { // advanced search
                self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBAdvancedSearchViewController")
            } else if section == 2 { // single herbs
                if row == 0
                {
                    return
                }else if row == 1 {
                    self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBCategoriesListViewController")
                    (self.presentViewController as! FBCategoriesListViewController).type = CategoryType.herb
                } else if row == 2 { // add new herb
                    let vc = profileStoryboard.instantiateViewController(withIdentifier: "FBProfileViewController") as! FBProfileViewController
                    let alert = UIAlertController.init(title: "Add Herb", message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction.init(title: "Create New", style: .default, handler: { action in
                        vc.profileViewType = ProfileViewType.createHerb
                        self.removePresentView()
                        self.addChildControllerView(vc as UIViewController, withMenuButton: false)
                    }))
                    alert.addAction(UIAlertAction.init(title: "Update Existing", style: .default, handler: { action in
                        let herbSearchViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBHerbSearchViewController") as! FBHerbSearchViewController
                        herbSearchViewController.profilePageType = .updateHerb
                        herbSearchViewController.shouldNotShowReadyOnly = true
                        self.removePresentView()
                        self.addChildControllerView(herbSearchViewController as UIViewController)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            } else if section == 3 { // Formula
                if row == 0
                {
                    return
                }else if row == 1 { // category
                    self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBCategoriesListViewController")
                    (self.presentViewController as! FBCategoriesListViewController).type = CategoryType.formula
                } else if row == 2 { //  add new formula
                    let alert = UIAlertController.init(title: "Add Formula", message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction.init(title: "Create New", style: .default, handler: { action in
                        let vc = profileStoryboard.instantiateViewController(withIdentifier: "FBProfileViewController") as! FBProfileViewController
                        vc.profileViewType = ProfileViewType.createFormula
                        if (self.homeViewController != nil) {
                            vc.addToFormulaHerbs = self.homeViewController.output.herbSearchViewController.addToFormulaHerbs
                        }
                        self.removePresentView()
                        self.addChildControllerView(vc as UIViewController, withMenuButton: false)
                    }))
                    alert.addAction(UIAlertAction.init(title: "Save Current Formula", style: .default, handler: { action in
                        let vc = profileStoryboard.instantiateViewController(withIdentifier: "FBProfileViewController") as! FBProfileViewController
                        vc.profileViewType = ProfileViewType.createFormula
                        if (self.homeViewController != nil) {
                            vc.addToFormulaHerbs = self.homeViewController.output.herbSearchViewController.addToFormulaHerbs
                        }
                        self.removePresentView()
                        self.addChildControllerView(vc as UIViewController, withMenuButton: false)
                    }))
                    alert.addAction(UIAlertAction.init(title: "Update Existing", style: .default, handler: { action in
                        let formulaSearchViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBFormulaSearchViewController") as! FBFormulaSearchViewController
                        formulaSearchViewController.profilePageType = .updateFormula
                        formulaSearchViewController.shouldNotShowReadyOnly = true
                        self.removePresentView()
                        self.addChildControllerView(formulaSearchViewController as UIViewController)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            } else if section == 5 { // recent search
                self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBRecentSearchesViewController")
            } else if section == 6 { // settings
                if row == 0
                {
                    self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBSettingsViewController")
                } else if  row == 1
                {
                    self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBReferencesViewController")
                }
            }
//            else if section == 7 {
//                if row == 0 { // report bugs
//                    self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBReportBugsViewController")
//                } else if row == 1 { // request content
//                    self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBRequestContentViewController")
//                } else { // references
//                    self.presentViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBReferencesViewController")
//                }
//            }
            
            if self.presentViewController != nil {
                self.removePresentView()
                self.addChildControllerView(self.presentViewController)
            }
        }
    }

}
    

    
    
    
    
