//  util.swift
//  wifi_script
//
//  Created by Maximilian Springenberg
//  Copyright © 2018 Maximilian Springenberg. All rights reserved.
import Foundation
import CoreWLAN


// scanner for networks
class NetworkScanner {
    var currentInterface: CWInterface
    var interfacesNames: [String] = []
    var networks: Set<CWNetwork> = []
    var client: CWWiFiClient = CWWiFiClient()
    
    // setting the interface automatically, can fail
    init?() {
        if let defaultInterface = CWWiFiClient.shared().interface(),
            let name = defaultInterface.interfaceName {
            self.currentInterface = defaultInterface
            self.interfacesNames.append(name)
            self.findNetworks()
        } else {
            return nil
        }
    }
    
    // setting the interface with the literal interface name (the likes of "en1")
    init(name: String) {
        self.currentInterface = self.client.interface(withName:name)!
        self.interfacesNames.append(name)
        self.findNetworks()
    }
    
    // fetching detectable WIFI networks
    func findNetworks() {
        do {
            self.networks = try currentInterface.scanForNetworks(withSSID:nil)
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    // fetching specific Network
    func getNetwork(withSSID: String) -> CWNetwork? {
        for network in self.networks {
            if ssid == network.ssid {
                return network
            }
        }
        return nil
    }
}


// easy access to lines in .txt files
class TxtDataLoader {
    var filePath : String
    var lines : Array<Substring>
    
    // trying to load the file, can fail
    init?(forResource: String){
        self.filePath = Bundle.main.path(forResource: forResource, ofType: "txt")!
        do {
            let content = try String(contentsOfFile: self.filePath)
            lines = content.split(separator: "\n")
        } catch {
            return nil
        }
    }
}
