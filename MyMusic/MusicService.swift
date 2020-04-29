//
//  MusicService.swift
//  MyMusic
//
//  Created by Abylaikhan Koshanov on 4/29/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import Foundation

class MusicService {

    static let shared = MusicService()
    
    func searchForMusic(search: String, completion: @escaping (MusicSearchResponse?, Error?) -> ()) {
        let url = URL(string: "https://itunes.apple.com/search?term=\(search)&entity=song")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MusicSearchResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    class MusicSearchResponse: Codable {
        var tracks: [Track]
        
        enum CodingKeys: String, CodingKey {
            case tracks = "results"
        }
    }
    
    func download(track: Track, url: URL, completion: @escaping (URL?, Error?) -> ()) {
        URLSession.shared.downloadTask(with: track.previewUrl) { tempURL, _, error in
            if let tempURL = tempURL {
                do {
                    let url = self.getFileUrl(for: track, url: url)
                    try FileManager.default.moveItem(at: tempURL, to: url)
                    DispatchQueue.main.async {
                        completion(url, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    func getFileUrl(for track: Track, url: URL) -> URL {

           let url = url.appendingPathComponent(track.previewUrl.lastPathComponent)
           
           return url
    }
}
