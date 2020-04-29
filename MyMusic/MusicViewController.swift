//
//  MusicViewController.swift
//  MyMusic
//
//  Created by Abylaikhan Koshanov on 4/29/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import UIKit

class MusicViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var tableView: UITableView!
        var tracks: [Track] = []
        var url: URL?
        var search: String = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            getTracks(search: search)
        }
        
        @objc func getTracks(search: String) {
            MusicService.shared.searchForMusic(search: search) { [weak self] result, error in
                guard let self = self else { return }
                if let tracks = result?.tracks {
                    print(tracks)
                    self.tracks = tracks
                    self.tableView.reloadData()
                } else if let error = error {
                    print(error)
                }
            }
        }
    }

    extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.tracks.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
            cell.track = self.tracks[indexPath.row]
            cell.folderURL = self.url
            return cell
        }
    }

    extension MusicViewController: UISearchBarDelegate {
        
        func searchBarSearch(_ searchBar: UISearchBar)
        {
            self.searchBar.endEditing(true)
        }
        
        func searchBarText(_ searchBar: UISearchBar) {
            search = searchBar.text ?? ""
            tracks = []
            getTracks(search: search)
        }
    }
    

