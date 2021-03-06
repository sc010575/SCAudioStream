//
//  AVPlayerWrapperTests.swift
//  SCAudioStreamTest
//
//  Created by Suman Chatterjee on 23/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import AVFoundation
import XCTest
@testable import SCAudioStream

class AVPlayerWrapperTests: XCTestCase {

  var wrapper: AVPlayerWrapper!
  var holder: AVPlayerWrapperDelegateMock!
  var url: URL!

  override func setUp() {
    super.setUp()
    wrapper = AVPlayerWrapper()
    wrapper.volume = 0.0
    holder = AVPlayerWrapperDelegateMock()
    wrapper.delegate = holder
    url = URL(fileURLWithPath: audioItemPath())
  }

  override func tearDown() {
    wrapper = nil
    holder = nil
    super.tearDown()
  }

// MARK: - State tests

  func test_AVPlayerWrapper__state__should_be_idle() {
    XCTAssert(wrapper.state == AVPlayerWrapperState.idle)
  }

  func test_AVPlayerWrapper__state__when_loading_a_source__should_be_loading() {
    wrapper.load(from: url, playWhenReady: false)
    XCTAssertEqual(wrapper.state, AVPlayerWrapperState.loading)
  }
  
  func test_AVPlayerWrapper__state__when_loading_a_source__should_eventually_be_ready() {
      let expectation = XCTestExpectation()
      holder.stateUpdate = { state in
          if state == .ready {
              expectation.fulfill()
          }
      }
      wrapper.load(from: url, playWhenReady: false)
      wait(for: [expectation], timeout: 20.0)
  }
  
  func test_AVPlayerWrapper__state__when_playing_a_source__should_be_playing() {
      let expectation = XCTestExpectation()
      holder.stateUpdate = { state in
          if state == .playing {
              expectation.fulfill()
          }
      }
      wrapper.load(from: url, playWhenReady: true)
      wait(for: [expectation], timeout: 20.0)
  }
  
  func test_AVPlayerWrapper__state__when_pausing_a_source__should_be_paused() {
      let expectation = XCTestExpectation()
      holder.stateUpdate = { state in
          switch state {
          case .playing: self.wrapper.pause()
          case .paused: expectation.fulfill()
          default: break
          }
      }
      wrapper.load(from: url, playWhenReady: true)
      wait(for: [expectation], timeout: 20.0)
  }
  
  func test_AVPlayerWrapper__state__when_toggling_from_play__should_be_paused() {
      let expectation = XCTestExpectation()
      holder.stateUpdate = { state in
          switch state {
          case .playing: self.wrapper.togglePlaying()
          case .paused: expectation.fulfill()
          default: break
          }
      }
      wrapper.load(from: url, playWhenReady: true)
      wait(for: [expectation], timeout: 20.0)
  }
  
  func test_AVPlayerWrapper__state__when_stopping__should_be_stopped() {
      let expectation = XCTestExpectation()
      holder.stateUpdate = { state in
          switch state {
          case .playing: self.wrapper.stop()
          case .idle: expectation.fulfill()
          default: break
          }
      }
      wrapper.load(from: url, playWhenReady: true)
      wait(for: [expectation], timeout: 20.0)
  }
  
  
  // MARK: - Duration tests
  
  func test_AVPlayerWrapper__duration__should_be_0() {
      XCTAssert(wrapper.duration == 0.0)
  }
  
  func test_AVPlayerWrapper__duration__loading_a_source__should_not_be_0() {
      let expectation = XCTestExpectation()
      holder.stateUpdate = { _ in
          if self.wrapper.duration > 0 {
              expectation.fulfill()
          }
      }
      wrapper.load(from: url, playWhenReady: false)
      wait(for: [expectation], timeout: 20.0)
  }
  
  // MARK: - Current time tests
  
  func test_AVPlayerWrapper__currentTime__should_be_0() {
      XCTAssert(wrapper.currentTime == 0)
  }
  
  // MARK: - Seeking
  
  func test_AVPlayerWrapper__seeking__should_seek() {
      let seekTime: TimeInterval = 5.0
      let expectation = XCTestExpectation()
      holder.stateUpdate = { state in
          self.wrapper.seek(to: seekTime)
      }
      holder.didSeekTo = { seconds in
          expectation.fulfill()
      }
      wrapper.load(from: url, playWhenReady: false)
      wait(for: [expectation], timeout: 20.0)
  }
  
  func test_AVPlayerWrapper__loading_source_with_initial_time__should_seek() {
      let expectation = XCTestExpectation()
      holder.didSeekTo = { seconds in
          expectation.fulfill()
      }
      wrapper.load(from: url, playWhenReady: false, initialTime: 4.0)
      wait(for: [expectation], timeout: 20.0)
  }
  
}
