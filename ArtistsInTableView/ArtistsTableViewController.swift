//
//  ArtistsTableViewController.swift
//  ArtistsInTableView
//
//  Created by AAK on 3/11/16.
//  Copyright © 2016 SSU. All rights reserved.
//

import UIKit

class ArtistsTableViewController: UITableViewController {
    
    var artistsDS: ArtistDataSource?
    var downloadAssistant = Download(withURLString: "https://blue.cs.sonoma.edu/~dsmith/")

    override func viewDidLoad() {
        super.viewDidLoad()

        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil) //whenever the data changes on this object or it completes its download Observe
        downloadAssistant.download_request() // store the downloaded
        title = "Artists"
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(downloadAssistant.dataFromServer!)
        artistsDS = ArtistDataSource(dataSource: downloadAssistant.dataFromServer!) //say that the data has been downloaded and is ready to use
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }

    deinit {
        downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ads = artistsDS { //if data source is set, which is checked in the observationValue
            return ads.numArtists()
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)

        if let theCell = cell as? ArtistTableViewCell, let artist = artistsDS?.artistAt(indexPath.row) {
            theCell.useArtist(artist)
        }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowArtistDetails" {
            /*
            if let row = tableView.indexPathForSelectedRow?.row {
                let artist = artistsDS?.artistAt(row)
                let detailedVC = segue.destinationViewController as! ArtistDetailedViewController
                detailedVC.artistForThisView(artist!)
            }
            */
            // OR
            let cell = sender as! ArtistTableViewCell
            if let indexPath = tableView.indexPath(for: cell), let ds = artistsDS {
                let detailedVC = segue.destination as! ArtistDetailedViewController
                detailedVC.artistForThisView(ds.artistAt(indexPath.row))
            }
            
        }
        
        
    }


}
