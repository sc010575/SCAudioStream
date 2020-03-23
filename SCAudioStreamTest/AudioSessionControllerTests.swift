//
//  AudioSessionControllerTests.swift
//  SCAudioStreamTest
//
//  Created by Suman Chatterjee on 23/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import AVFoundation
import XCTest
@testable import SCAudioStream

class AudioSessionControllerTests: XCTestCase {

  let audioSessionController: AudioSessionController = AudioSessionController(audioSession: SuccessfulAudioSession())

  let failedAudioSessionController: AudioSessionController = AudioSessionController(audioSession: FallibleAudioSession())

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

// MARK: - State tests

  func test_AudioSessionController__should_be_inActive() {
    XCTAssertFalse(audioSessionController.audioSessionIsActive)
  }
  
  func test_AudioSessionControlle__when__session__is_activated() {
    try? audioSessionController.activateSession()
    XCTAssertTrue(audioSessionController.audioSessionIsActive)
  }
  
  func test_when__deactivating__session__should__be__inactive() {
    try? audioSessionController.deactivateSession()
    XCTAssertFalse(audioSessionController.audioSessionIsActive)

  }
  
  func test_when__a__failing__AudioSession_when__activated__should__be__inactive() {
      try? failedAudioSessionController.activateSession()
      XCTAssertFalse(failedAudioSessionController.audioSessionIsActive)
  }
}
