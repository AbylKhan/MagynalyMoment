//
//  MusicTableViewCell.swift
//  MyMusic
//
//  Created by Abylaikhan Koshanov on 4/29/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var button:UIButton!
        
        var track: Track! {
            didSet {
                self.titleLabel.text = track.trackName
            }
        }
        
        var folderURL: URL?
        
        @IBAction func downloadButton(_ sender: Any) {
            MusicService.shared.download(track: track, url: folderURL ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] ) { url, error in
                if let url = url {
                    self.button.isHidden = true
                } else if let error = error {
                    print(error)
                }
            }
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
