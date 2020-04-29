//
//  playerViewController.swift
//  MyMusic
//
//  Created by Abylaikhan Koshanov on 4/28/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//
import Foundation
import AVFoundation
import UIKit

class playerViewController: UIViewController {
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    var musicURL: URL! {
        didSet {
            playerItem = .init(url: musicURL)
        }
    }

     @IBAction func play(_ sender: Any) {
          self.player = AVPlayer(playerItem:playerItem)
          player?.volume = 1.0
          player?.play()
      }
      
      @IBAction func stop(_ sender: Any) {
          player?.pause()
      }

      override func viewDidLoad() {
          super.viewDidLoad()
      }
      
      override func viewWillDisappear(_ animated: Bool) {
          player?.pause()
          playerItem = nil
      }
    
}


