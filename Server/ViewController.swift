//
//  ViewController.swift
//  Server
//
//  Created by Tom Singleton on 26/01/2020.
//  Copyright © 2020 Tom Singleton. All rights reserved.
//

import UIKit
import Swifter

class ViewController: UIViewController {

    let server = HttpServer()
    @IBOutlet var url: UILabel!
    
    enum WiFiError: String, Error {
        case noIP = "No IP Address available. Make sure you are connected."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let fileManager = FileManager.default
        do {
            let documnetsDir = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            server["/:path"] = directoryBrowser(documnetsDir.path)
            try server.start()
            
            guard let ip = getWiFiAddress() else {
                throw WiFiError.noIP
            }
            
            url.text = "\(ip):8080/files/"
        }
        catch {
            url.numberOfLines = 0
            url.text = error.localizedDescription
            
            url.minimumScaleFactor = 1
        }
    }


}

// Return IP address of WiFi interface (en0) as a String, or `nil`
func getWiFiAddress() -> String? {
    var address : String?

    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }

    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee

        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if  name == "en0" {

                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)

    return address
}

