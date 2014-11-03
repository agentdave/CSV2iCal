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
	@IBOutlet weak var calendarSelectionController: NSArrayController!

	var eventStore = EKEventStore()
	dynamic var calendars:[EKCalendar] = []
	dynamic var calendar:EKCalendar?
	dynamic var csvContents:NSAttributedString?
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
		eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:{ granted, error in
			self.calendars = (self.eventStore.calendarsForEntityType(EKEntityTypeEvent) as [EKCalendar])
			self.calendar = self.eventStore.defaultCalendarForNewEvents
		})
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

	func createEvent() {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

		var error: NSErrorPointer = nil

		if let csv = CSV(csvString:self.csvContents?.string, error: error) {
			for row in csv.rows {
				let startDateString = row["Start Date"]!
				let startTimeString = row["Start Time"]!
				let endDateString = row["End Date"]!
				let endTimeString = row["End Time"]!
				
				let startString = "\(startDateString) \(startTimeString)"
				let endString = "\(endDateString) \(endTimeString)"
				
				var event = EKEvent(eventStore:eventStore)
				var writeError: NSError?
				event.title = row["Subject"]!
				event.startDate = dateFormatter.dateFromString(startString)
				event.endDate = dateFormatter.dateFromString(endString)
				event.allDay = (row["All Day Event"]! == "TRUE")
				event.notes = row["Description"]!
				event.location = row["Location"]!
				event.calendar = self.calendar!
				eventStore.saveEvent(event, span: EKSpanThisEvent, commit: true, error: &writeError)
			}
		}
	}
	
	@IBAction func addEvent(AnyObject) {
		self.createEvent()
	}
	
	@IBAction func loadCSV(AnyObject) {
		var openPanel = NSOpenPanel()
		openPanel.beginWithCompletionHandler { (result) -> Void in
			if let selectedFile = openPanel.URL {
				var error: NSErrorPointer = nil
				var csvString = String(contentsOfURL:selectedFile, encoding: NSUTF8StringEncoding, error:nil)?
				self.csvContents = NSAttributedString(string: csvString!)
			}
		}
	}
}

