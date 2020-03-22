//
//  SCAudioStreamTest.swift
//  SCAudioStreamTest
//
//  Created by Suman Chatterjee on 20/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import XCTest
@testable import SCAudioStream

class SCAudioStreamTest: XCTestCase {
  var sut : SCAudioStream?
    override func setUp() {
      sut = SCAudioStream("Suman")
  }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTitle() {
      let title = sut?.showTitle()
      XCTAssertEqual(title, "Suman")
    }
}
