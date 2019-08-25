//
//  SendGeoViewController.swift
//  Driver
//
//  Created by Татьяна Хохлова on 25/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class SendGeoViewController: UIViewController {

    @IBOutlet weak var sendGeoButton: UIButton!
    @IBOutlet weak var geoLabel: UILabel!
    
    var viewOutput: SendGeoViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewOutput.moduleWasLoaded()
        sendGeoButton.layer.cornerRadius = 4
        sendGeoButton.layer.borderColor = UIColor(named: "titleTextColor")?.cgColor
        sendGeoButton.layer.borderWidth = 2
    }

    @IBAction func sendGeo(_ sender: UIButton) {
        sender.startAnimating()
        viewOutput.sendGeo()
    }

    @IBAction func exit(_ sender: UIButton) {
        viewOutput.exit()
    }
    
}

extension SendGeoViewController: SendGeoViewInput {

    func updateGeo(latitude: Double, longitude: Double) {
        geoLabel.text = "(\(latitude), \(longitude))"
        sendGeoButton.isEnabled = true
    }

    func stopLoad() {
        sendGeoButton.stopAnimating()
    }
    
}
