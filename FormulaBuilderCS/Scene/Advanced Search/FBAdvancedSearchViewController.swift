//
//  FBAdvancedSearchViewController.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/10/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBAdvancedSearchViewControllerInput {
    func displaySomething(viewModel: FBAdvancedSearch.Something.ViewModel)
}

protocol FBAdvancedSearchViewControllerOutput {
    func doSomething(request: FBAdvancedSearch.Something.Request)
    var channelsViewController: FBChannelsViewController! { get set }
}

class FBAdvancedSearchViewController: UIViewController, FBAdvancedSearchViewControllerInput {
    
    @IBOutlet weak var Search: UISearchBar!
    
    var output: FBAdvancedSearchViewControllerOutput!
    var router: FBAdvancedSearchRouter!
    
    var speciesCellHeight: CGFloat = 44
    var flavourCellHeight: CGFloat = 44
    var naturesCellHeight: CGFloat = 44
    
    var species = [String]()
    var flavour = [String]()
    var natures = [String]()
    
    var selectedSpecies = [String]()
    var selectedFlavour = [String]()
    var selectedNatures = [String]()
    
    var latinNameTextField: UITextField!
    var sourceTextField: UITextField!
    
    @IBOutlet weak var pinyinTextField: UITextField!
    @IBOutlet weak var chineseNameTextField: UITextField!
    @IBOutlet weak var formulaSearchSourceTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    @IBOutlet weak var formulaSearchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var herbButton: UIButton!
    @IBOutlet weak var formulaButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var channelsViiewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomLineLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FBAdvancedSearchConfigurator.sharedInstance.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        FBCoreWorker.shared.getSpecies { species in
            self.species = species
        }
        
        FBCoreWorker.shared.getFlavour { flavour in
            self.flavour = flavour
        }
        
        FBCoreWorker.shared.getNatures { natures in
            self.natures = natures
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            if self.buttonBottomLineLeading.constant != 0 {
                self.buttonBottomLineLeading.constant = self.herbButton.frame.origin.x
            }
        }, completion: nil)
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: "FBSpeciesCell", bundle: nil), forCellReuseIdentifier: "Species Cell")
    }
    
    func displaySomething(viewModel: FBAdvancedSearch.Something.ViewModel) {}
    
    @IBAction func herbOrFormulaButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
        
        sender.setTitleColor(FBColor.hexColor_63A020(), for: .normal)
        buttonBottomLineLeading.constant = sender.frame.origin.x
        
        if sender == herbButton {
            formulaButton.setTitleColor(FBColor.hexColor_9B9B9B(), for: .normal)
            formulaSearchView.superview?.sendSubview(toBack: formulaSearchView)
        } else {
            herbButton.setTitleColor(FBColor.hexColor_9B9B9B(), for: .normal)
            formulaSearchView.superview?.bringSubview(toFront: formulaSearchView)
        }
        
        UIView.animate(withDuration: kDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func changeChannelsViiewHeight(with height: CGFloat) {
        channelsViiewHeight.constant = height
    }
    
    func gotoHerbSearchViewControllerWithResults(_ herbIDs: [String]) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "FBHerbSearchViewController") as! FBHerbSearchViewController
        viewController.title = kSearchResults
        viewController.resultIDs = herbIDs
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotoFormulaSearchViewControllerWithResults(_ formulaIDs: [String]) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "FBFormulaSearchViewController") as! FBFormulaSearchViewController
        viewController.title = kSearchResults
        viewController.resultIDs = formulaIDs
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func under_searchButtonClicked(_ sender: Any) {
        print("under search button clicked!")
        if buttonBottomLineLeading.constant == 0 { // search formula
            store.formulaAdvancedSearch(pinyin: pinyinTextField.text, chineseName: chineseNameTextField.text, sourceText: formulaSearchSourceTextField.text, author: authorTextField.text, completionHandler: { formulaIDs in
                
                if formulaIDs.isEmpty {
                    let alert = UIAlertController.init(title: "No formulas found", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.gotoFormulaSearchViewControllerWithResults(formulaIDs)
                }
            })
        }
        else{ // search herb
            let selectedChannelIDs = output.channelsViewController.selectedChannelIDs
            store.herbAdvancedSearch(latinName: latinNameTextField.text, species: selectedSpecies, flavours: selectedFlavour, natures: selectedNatures, sourceText: sourceTextField.text, channelIDs: selectedChannelIDs, completionHandler: { herbIDs in
                if herbIDs.isEmpty {
                    let alert = UIAlertController.init(title: "No herbs found", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.gotoHerbSearchViewControllerWithResults(herbIDs)
                }
            })
        }
        
    }
    
    @IBAction func clearAllSearch(_ sender: Any) {
        if buttonBottomLineLeading.constant == 0 {
            pinyinTextField.text = ""
            chineseNameTextField.text = ""
            formulaSearchSourceTextField.text = ""
            authorTextField.text = ""
        }
        else{
            latinNameTextField.text = ""
            selectedSpecies.removeAll()
            selectedFlavour.removeAll()
            selectedNatures.removeAll()
            speciesCellHeight = 44
            flavourCellHeight = 44
            naturesCellHeight = 44
            sourceTextField.text = ""
            output.channelsViewController.selectedChannelIDs.removeAll()
            output.channelsViewController.selectedChannels.removeAll()
            output.channelsViewController.fetchChannels()
            tableView.reloadData()
        }
    }
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        if buttonBottomLineLeading.constant == 0 { // search formula
            store.formulaAdvancedSearch(pinyin: pinyinTextField.text, chineseName: chineseNameTextField.text, sourceText: formulaSearchSourceTextField.text, author: authorTextField.text, completionHandler: { formulaIDs in
                
                if formulaIDs.isEmpty {
                    let alert = UIAlertController.init(title: "No formulas found", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.gotoFormulaSearchViewControllerWithResults(formulaIDs)
                }
            })
        } else { // search herb
            let selectedChannelIDs = output.channelsViewController.selectedChannelIDs
            store.herbAdvancedSearch(latinName: latinNameTextField.text, species: selectedSpecies, flavours: selectedFlavour, natures: selectedNatures, sourceText: sourceTextField.text, channelIDs: selectedChannelIDs, completionHandler: { herbIDs in
                if herbIDs.isEmpty {
                    let alert = UIAlertController.init(title: "No herbs found", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.gotoHerbSearchViewControllerWithResults(herbIDs)
                }
            })
        }
    }
}

extension FBAdvancedSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x: CGFloat = 15
        let height: CGFloat = 44
        let screenWidth = UIScreen.main.bounds.size.width
        
        if indexPath.row == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell 0")
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell 0")
            }
            
            if latinNameTextField == nil {
                latinNameTextField = UITextField.init(frame: CGRect(x: x, y: 0, width: screenWidth - x*2, height: height))
                latinNameTextField.placeholder = "Latin name type"
                latinNameTextField.font = FBFont.SFUIText_Regalur17()
//                latinNameTextField.textColor = FBColor.hexColor_4A4A4A()
                latinNameTextField.returnKeyType = .done
                latinNameTextField.delegate = self
            }
            
            cell!.contentView.addSubview(latinNameTextField)
            
            return cell!
            
        } else
            if indexPath.row == 1 {
            
            let specieCell = tableView.dequeueReusableCell(withIdentifier: "Species Cell") as! FBSpeciesCell
            specieCell.speciesDelegate = self
            specieCell.nameLabel.text = "Species"
            specieCell.configure(with: selectedSpecies, index: indexPath)
            
            return specieCell
            
        }  else if indexPath.row == 2 {
            
            let flavourCell = tableView.dequeueReusableCell(withIdentifier: "Species Cell") as! FBSpeciesCell
            flavourCell.speciesDelegate = self
            flavourCell.nameLabel.text = "Flavour"
            flavourCell.configure(with: selectedFlavour, index: indexPath)
            
            return flavourCell
            
        }  else if indexPath.row == 3 {
            
            let natureCell = tableView.dequeueReusableCell(withIdentifier: "Species Cell") as! FBSpeciesCell
            natureCell.speciesDelegate = self
            natureCell.nameLabel.text = "Natures"
            natureCell.configure(with: selectedNatures, index: indexPath)
            
            return natureCell
            
        } else if indexPath.row == 4 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell 4")
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell 4")
            }
            
            if sourceTextField == nil {
                sourceTextField = UITextField.init(frame: CGRect(x: x, y: 0, width: screenWidth - x*2, height: height))
                sourceTextField.placeholder = "Source text"
                sourceTextField.font = FBFont.SFUIText_Regalur17()
                sourceTextField.returnKeyType = .done
                sourceTextField.delegate = self
            }
            
            cell!.contentView.addSubview(sourceTextField)
            
            return cell!
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            return speciesCellHeight
        } else if indexPath.row == 2 {
            return flavourCellHeight
        } else if indexPath.row == 3 {
            return naturesCellHeight
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "FBSpeciesViewController") as! FBSpeciesViewController
        viewController.delegate = self
        
        if indexPath.row == 1 { // species
            viewController.title = "Species"
            viewController.allValues = species
            viewController.selectedValues = selectedSpecies
        } else if indexPath.row == 2 {
            viewController.allValues = flavour
            viewController.title = "Flavour"
            viewController.selectedValues = selectedFlavour
        } else if indexPath.row == 3 {
            viewController.allValues = natures
            viewController.title = "Natures"
            viewController.selectedValues = selectedNatures
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK:

extension FBAdvancedSearchViewController: FBSpeciesViewControllerDelegate {
    
    func selectedValues(_ values: [String], title: String) {
        var row = 0
        
        if title == "Species" {
            selectedSpecies = values
            row = 1
        } else if title == "Flavour" {
            selectedFlavour = values
            row = 2
        } else {
            selectedNatures = values
            row = 3
        }
        
        let indexPath = IndexPath.init(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

// MARk:

extension FBAdvancedSearchViewController: FBSpeciesCellDelegate {
    
    func cellHeight(_ height: CGFloat, removedValue: String?, title: String) {

        if removedValue != nil || height > 46 {
            
            var row = 0
            
            if title == "Species" {
                row = 1
            } else if title == "Flavour" {
                row = 2
            } else {
                row = 3
            }
            
            if removedValue != nil {
                if title == "Species" {
                    selectedSpecies.remove(at: selectedSpecies.index(of: removedValue!)!)
                } else if title == "Flavour" {
                    selectedFlavour.remove(at: selectedFlavour.index(of: removedValue!)!)
                } else {
                    selectedNatures.remove(at: selectedNatures.index(of: removedValue!)!)
                }
            }
            
            if height < 44 {
                if title == "Species" {
                    speciesCellHeight = 44
                } else if title == "Flavour" {
                    flavourCellHeight = 44
                } else {
                    naturesCellHeight = 44
                }
                
            } else {
                if title == "Species" {
                    speciesCellHeight = height
                } else if title == "Flavour" {
                    flavourCellHeight = height
                } else {
                    naturesCellHeight = height
                }
            }
            
            let indexPath = IndexPath.init(row: row, section: 0)
            tableView.reloadRows(at: [indexPath], with: .fade)
            
            tableViewHeight.constant = 44 * 2 + speciesCellHeight + flavourCellHeight + naturesCellHeight
        }
    }
}

// MARK: UITextFieldDelegate

extension FBAdvancedSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}








