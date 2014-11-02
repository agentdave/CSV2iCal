//
//  AppDelegate.swift
//  CSV2iCal
//
//  Created by David Ackerman on 2014-11-01.
//  Copyright (c) 2014 David Ackerman. All rights reserved.
//

import Cocoa
import EventKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
		var eventStore = EKEventStore()
		eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:{ granted, error in
			print("access granted")
			var event = EKEvent(eventStore:eventStore)
			var writeError: NSError?
			event.title = "Testing"
			event.startDate = NSDate()
			event.endDate = event.startDate.dateByAddingTimeInterval(3600)
			//		var calendar = EKCalendar()
			event.calendar = eventStore.defaultCalendarForNewEvents
			eventStore.saveEvent(event, span: EKSpanThisEvent, commit: true, error: &writeError)
			print(writeError)
		})
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

