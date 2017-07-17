//
//  FBChannelTagsCellTableViewCell.swift
//  FormulaBuilderCS
//
//  Created by a on 2/20/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
import FormulaBuilderCore

class FBChannelTagsCell: FBBaseTableViewCell {

    @IBOutlet weak var tagView: SKTagView!
    @IBOutlet weak var addChannelPanel: UIView!
    
    var savedChannels : [FBChannel]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(channels: [FBChannel], profileViewType: ProfileViewType) {
        savedChannels = channels
        
        tagView.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        tagView.padding = UIEdgeInsetsMake(8, 6, 8, 6)
        tagView.interitemSpacing = 8
        tagView.lineSpacing = 8
        
        tagView.removeAllTags()
        
        if (channels.count > 0) {
        
            for channel in channels {
                let tag : SKTag = SKTag(text: channel.englishName, chineseText: channel.chineseName, iconName: channel.iconName)
                tag.textColor = FBColor.hexColor_4A4A4A()
                tag.chineseTextColor = FBColor.hexColor_B4B4B4()
                
                tag.fontSize = 15
                tag.chineeseTextFontSize = 15
                
                tag.font = FBFont.SFUIText_Regalur17()
                tag.chineseTextfont = FBFont.PingFangSC_Regular17()
                
                tag.padding = UIEdgeInsetsMake(5, 20, 5, 15)
                tag.bgImg = UIImage(color: FBColor.hexColor_F7F7F7())
                tag.cornerRadius = 5
                tag.enable = false
                tagView.addTag(tag)
            }
        }
        
        if (profileViewType == .view) {
            addChannelPanel.removeConstraints(addChannelPanel.constraints);
            addChannelPanel.isHidden = true
        }
    }
    
    @IBAction func addChannelBtnTapped(_ sender: Any) {
        guard let vc = self.parentViewController else {
            return
        }
        
        let addChannelVC = mainStoryboard.instantiateViewController(withIdentifier: "FBChannelsViewController") as! FBChannelsViewController
        addChannelVC.output.profileViewController = self.parentViewController as! FBProfileViewController?
        if (savedChannels != nil) {
            addChannelVC.selectedChannels = savedChannels!
            addChannelVC.selectedChannelIDs = savedChannels!.map({$0.id})
        }
        vc.navigationController?.pushViewController(addChannelVC, animated: true)
    }
}
