//
//  Assignment2Tests.swift
//  Assignment2Tests
//
//  Created by 최원우 on 25/4/2023.
//

import XCTest
@testable import Assignment2

import SwiftUI
import CoreData

final class Assignment2Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testImageUpload() {
        let contentView = ContentView(mapmodel: MapPlace())

        XCTAssertNotNil(contentView.body)
    }
    func testView(){

        let contentView = ContentView(mapmodel: MapPlace())
        XCTAssert(contentView.image is Image)
    }
    
    func testPlace(){
        let contentView = ContentView(mapmodel: MapPlace())
        XCTAssert(contentView.places is FetchedResults<Places>)
    }
    func testDefaultImage(){
        let contentView = ContentView(mapmodel: MapPlace())
        let placesTest = contentView.places
        XCTAssert(defaultImage is Image)
    }
    func testLatStr(){
        let model=MapPlace.shared
        model.latStr="45"
         
        model.latStr="91"
        XCTAssert(model.latStr=="91")
        model.latStr="-12.123456"
        XCTAssert(model.latStr=="-12.12346")
    }
    
    func testMapViewType(){
        let contentView = ContentView(mapmodel: MapPlace())

        let mapview = MapView(place:Places(), mapmodel: MapPlace())

        XCTAssert(mapview.mapzoom is Double)
        XCTAssert(mapview.maplatitude is String)
        XCTAssert(mapview.maplongitude is String)
    }
    func testMapModelType(){
        let mapmodel = MapPlace()
        XCTAssert(mapmodel.name is String)
        XCTAssert(mapmodel.latitude is Double)
        XCTAssert(mapmodel.longitude is Double)
        XCTAssert(mapmodel.delta is Double)
        
    }
    func testFROMZOOMTODELTA(){
        let mapmodel = MapPlace()
        let delta = 10.0
        mapmodel.fromZoomToDelta(delta)
        mapmodel.setupRegion()
        
        XCTAssert(mapmodel.region.span.longitudeDelta == 100)
    }
    
    
}

