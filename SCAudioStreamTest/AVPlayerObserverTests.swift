//
//  AVPlayerObserverTests.swift
//  SCAudioStreamTest
//
//  Created by Suman Chatterjee on 24/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import XCTest
import AVFoundation
@testable import SCAudioStream

class AVPlayerObserverTests: XCTestCase {
  var holder: AVPlayerObserverDelegateMock!

  var player: AVPlayer!
  var observer: AVPlayerObserver!

  override func setUp() {
    player = AVPlayer()
    player.volume = 0.0
    observer = AVPlayerObserver()
    observer.player = player
    holder = AVPlayerObserverDelegateMock()
    observer.delegate = holder
  }

  override func tearDown() {
    player = nil
    holder = nil
    super.tearDown()
  }

  func test__at__initiation__Observing_Noting() {
    XCTAssertFalse(observer.isObserving)
  }

  func test__when__startObserving__should__update__delegateStatus() {
    observer.startObserving()
    XCTAssertTrue(observer.isObserving)
    let url = URL(fileURLWithPath: audioItemPath())
    player.replaceCurrentItem(with: AVPlayerItem(url: url))
    player.play()

    let expectation = XCTestExpectation()
    holder.statusUpdate = { status in
      expectation.fulfill()
      XCTAssertNotNil(self.holder.status)
      XCTAssertEqual(self.holder.status, .readyToPlay)
    }
    wait(for: [expectation], timeout: 10.0)
  }
  
  func test__when__startObserving__should__update__delegate__timeIntervalStatus() {
    observer.startObserving()
    XCTAssertTrue(observer.isObserving)
    let url = URL(fileURLWithPath: audioItemPath())
    player.replaceCurrentItem(with: AVPlayerItem(url: url))

    let expectation = XCTestExpectation()
    holder.timeControlStatusUpdate = { status in
      expectation.fulfill()
      XCTAssertNotNil(self.holder.timeControlStatus)
      XCTAssertEqual(self.holder.timeControlStatus, .waitingToPlayAtSpecifiedRate)
    }
    player.play()
    wait(for: [expectation], timeout: 10.0)
  }
}
