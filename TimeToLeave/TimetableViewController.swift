//
//  TimetableViewController.swift
//  TimeToLeave
//
//  Created by James Liu on 20/10/18.
//  Copyright © 2018 James Liu. All rights reserved.
//

import Cocoa
import SwiftPTV

class TimetableViewController: NSViewController {
    
    @IBOutlet weak var minsToNextDeparture: NSTextField!
    @IBOutlet weak var minsToNextDepartureDesc: NSTextField!
    
    @IBOutlet weak var loadingView: NSView!
    @IBOutlet weak var resultsView: NSView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animate the loading indicator
        self.loadingIndicator.startAnimation(self)
        
        // Hide all UI elements whilst loading
        self.resultsView.isHidden = true
        self.loadingView.isHidden = false
        
        
        PTVHelpers.getStopsNear(location: Location(latitude: -37.8584388, longitude: 145.0268829), routeTypes: [0]) { response in
        }
        
        PTVHelpers.getNextDeparturesFrom(stopId: 1071, routeId: 12, direction: 11) { response in
            // Hide loading indicator and show results
            DispatchQueue.main.async {
                self.resultsView.isHidden = false
                self.loadingView.isHidden = true
                self.loadingIndicator.stopAnimation(self)
                
                if response!.count > 0 {
                    let nextDept = response![0]
                    
                    self.updateNextDeparture(nextDept)
                } else {
                    print("No departures found")
                }
            }
        }
    }
    
    fileprivate func updateNextDeparture(_ departure: Departure) {
        let departureTime = departure.scheduledDeparture?.toLocalTime()
        let minutesToDeparture = departureTime?.minutesFromNow()
        
        
        self.minsToNextDeparture.stringValue = String(minutesToDeparture!)
    }
}

extension TimetableViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> TimetableViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("TimetableViewController")
        
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? TimetableViewController else {
            fatalError("Why can't I find TimetableViewController? - Check Main.storyboard")
        }
        
        return viewController
    }
}
