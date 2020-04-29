//
//  ViewController.swift
//  MyMusic
//
//  Created by Abylaikhan Koshanov on 4/29/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
       var itemMenuArray = [Menu]()

       override func viewDidLoad() {
           super.viewDidLoad()
          
    }
    override func viewWillAppear(_ animated: Bool) {

           reFiles(url: self.url)
        
        let addFolderButton = UIBarButtonItem(title: "Add Folder",  style: .plain, target: self, action: #selector(addFolder))
        let addMusicButton = UIBarButtonItem(title: "Add Music",   style: .plain, target: self, action: #selector(addMusic))
        
        navigationItem.rightBarButtonItems = [addFolderButton]
        navigationItem.leftBarButtonItems = [addMusicButton]

       }
    
    var url = try! FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var fileURLs: [URL] = try! FileManager.default.contentsOfDirectory(at: try! FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    
    @objc func addFolder() {
           let alert = UIAlertController(title: "Enter New Folder Name", message: nil, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
           alert.addTextField { (textField) in
               textField.text = "NewFolder"
           }
           alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
               let textField = alert.textFields![0]
               let dataPath = self.url.appendingPathComponent(textField.text ?? "NewFolder")
               do {
                   try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)
                   self.reFiles(url: self.url)
               } catch {
                   print(error.localizedDescription)
               }
           }))
           
           self.present(alert, animated: true, completion: nil)
       }
       
       @objc func addMusic() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addMusicVC = storyboard.instantiateViewController(identifier: "MusicViewController") as MusicViewController
           addMusicVC.url = self.url
          navigationController?.pushViewController(addMusicVC, animated: true)
       }
    
    func reFiles(url: URL) {
           do {
               self.fileURLs = try! FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
               collectionView.reloadData()
           } catch {
               print(error.localizedDescription)
           }
           collectionView.reloadData()
       }
    
  
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if fileURLs[indexPath.row].pathExtension == "mp3"{
                let playerVC = storyboard.instantiateViewController(identifier: "playerViewController") as playerViewController
                playerVC.musicURL = fileURLs[indexPath.row]
              navigationController?.pushViewController(playerVC, animated: true)
            } else {
                let directoryVC = storyboard.instantiateViewController(identifier: "ViewController") as ViewController
                directoryVC.url = fileURLs[indexPath.row]
                reFiles(url: self.url)
                navigationController?.pushViewController(directoryVC, animated: true)
            }
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return fileURLs.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as? MenuCollectionViewCell {
               itemCell.label.text = fileURLs[indexPath.row].lastPathComponent
               return itemCell
           }
           return UICollectionViewCell()
       }
}
