//
//  SettingsController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-27.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
import MapKit

enum SettingAction {
    case Location
    case RemovePersonalSettings
    case Info
    case FAQ
    case Privacy
    case Tutorial
}

class SettingsController: UIViewController {
    var settingAction : SettingAction?
    let settingsCell = "settingsCell"
    
    var containerView : UIView?
    
    @IBOutlet var settingsLabel: UILabel!
    @IBOutlet var settingsCollectionView: UICollectionView!
    
    var generalSectionLabels                        = ["Set Location", "Remove Personal Settings"]
    var helpSectionLabels                           = ["Information", "FAQ", "Terms and Privacy", "Tutorial"]
    var iconNamesForGeneral                         = ["settings_location_icon", "settings_remove_icon"]
    var iconNamesForHelp                            = ["settings_info_icon", "settings_FAQ_icon", "settings_privacy_icon", "settings_tutorial_icon"]
    var settingActionsForGeneral : [SettingAction]  = [.Location, .RemovePersonalSettings]
    var settingActionsForHelp : [SettingAction]     = [.Info, .FAQ, .Privacy, .Tutorial]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}

extension SettingsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return generalSectionLabels.count
        } else {
            return helpSectionLabels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingsCell, for: indexPath) as! SettingsCell
        let settingLabelAttributes = [NSAttributedStringKey.font: UIFont(name: "GillSans-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.orange]
        if indexPath.section == 0 {
            cell.settingLabel.attributedText    = createAtrributes(text: generalSectionLabels[indexPath.item], attributes: settingLabelAttributes)
            cell.settingIconImageView.image     = UIImage(named: iconNamesForGeneral[indexPath.item])
            cell.settingRightArrowBtn.isHidden  = true
            cell.settingAction                  = settingActionsForGeneral[indexPath.item]
            
        } else if indexPath.section == 1 {
            cell.settingLabel.attributedText    = createAtrributes(text: helpSectionLabels[indexPath.item], attributes: settingLabelAttributes)
            cell.settingIconImageView.image     = UIImage(named: iconNamesForHelp[indexPath.item])
            cell.settingAction                  = settingActionsForHelp[indexPath.item]
        }
        
        setupBottomBorder(cell: cell)
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSettingClicked)))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    @objc func handleSettingClicked(gesture: UITapGestureRecognizer) {
        if let view = gesture.view as? SettingsCell {
            settingAction = view.settingAction
            switch settingAction  {
            case .Location?:
                setupLocationViewContainer()
                setupLocationSettingHelper()
                break
            case .RemovePersonalSettings?:
                setupRemovePromptBox()
                break
            case .Info?:
                break
            case .FAQ?:
                break
            case .Privacy?:
                break
            case .Tutorial?:
                break
            default:
                break
            }
        }
    }
    
    func setupRemovePromptBox() {
        let alert = UIAlertController(title: "Remove Persnoal Settings", message: "Are you sure you want to remove all personal settings?", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let removeButton = UIAlertAction(title: "Remove", style: .default) { (action) in
            self.clearUserSetting()
        }
        alert.addAction(cancelButton)
        alert.addAction(removeButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    func clearUserSetting() {
        // TODO: clear user information here
        print("Clear user settings")
    }
}


// setting for loation

extension SettingsController {
    @objc func handleDismissView() {
        self.containerView?.backgroundColor = .clear
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.containerView?.frame = CGRect(x: 0, y: (self.containerView?.frame.height)!, width: (self.containerView?.frame.width)!, height: (self.containerView?.frame.height)!)
        }) { (completed) in
            if completed {
                self.containerView?.removeFromSuperview()
            }
        }
    }
    
    func setupLocationViewContainer() {
        containerView                               = UIView()
        containerView?.backgroundColor              = UIColor.black.withAlphaComponent(0.3)
        containerView?.isUserInteractionEnabled     = true
        containerView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissView)))
    }
    
    func setupLocationSettingHelper() {
        let locationSettingHelper                   = LocationSettingHelper()
        locationSettingHelper.settingsController    = self
        locationSettingHelper.containerView         = containerView
        locationSettingHelper.showLocationSettingBox()
    }
    
    func openMapInGoogleMap(location: CLLocationCoordinate2D) {
        //Working in Swift new versions.
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(Float(location.latitude)),\(Float(location.longitude))&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            NSLog("Can't use com.google.maps://");
        }
    }
}








