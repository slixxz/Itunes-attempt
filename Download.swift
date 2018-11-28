//
//  Download.swift
//  Navigation
//
//  Created by AAK on 3/10/16.
//  Copyright © 2016 SSU. All rights reserved.
//

import UIKit

class Download: NSObject {

    var urlString: String
    dynamic var dataFromServer: [AnyObject]?
    
    init(withURLString: String) {
        urlString = withURLString
        super.init()
    }
    
    func download_request()
    {
        
        if let url = URL(string: urlString) {
            do {
                let contents = try String(contentsOf: url)
                
                if let data = contents.data(using: .utf8) {
                    dataFromServer = try! JSONSerialization.jsonObject(with: data, options: []) as! [AnyObject]
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
}
