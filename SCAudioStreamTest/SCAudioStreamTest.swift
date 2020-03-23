//
//  SCAudioStreamTest.swift
//  SCAudioStreamTest
//
//  Created by Suman Chatterjee on 20/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import XCTest
@testable import SCAudioStream

class SCAudioStreamEventListener {

  var state: AudioPlayerState? {
    didSet {
      if let state = state {
        stateUpdate?(state)
      }
    }
  }

  var stateUpdate: ((_ state: AudioPlayerState) -> Void)?
  var secondsElapse: ((_ seconds: TimeInterval) -> Void)?
  var seekCompletion: (() -> Void)?

  weak var audioPlayer: SCAudioStream?

  init(audioPlayer: SCAudioStream) {
    audioPlayer.event.stateChange.addListener(self, handleDidUpdateState)
    audioPlayer.event.seek.addListener(self, handleSeek)
    audioPlayer.event.secondElapse.addListener(self, handleSecondsElapse)
  }

  deinit {
    audioPlayer?.event.stateChange.removeListener(self)
    audioPlayer?.event.seek.removeListener(self)
    audioPlayer?.event.secondElapse.removeListener(self)
  }

  func handleDidUpdateState(state: AudioPlayerState) {
    self.state = state
  }

  func handleSeek(data: SCAudioStream.SeekEventData) {
    seekCompletion?()
  }

  func handleSecondsElapse(data: SCAudioStream.SecondElapseEventData) {
    self.secondsElapse?(data)
  }

}

class SCAudioStreamTest: XCTestCase {
  var audioPlayer: SCAudioStream!
  var listener: SCAudioStreamEventListener!

  override func setUp() {
    super.setUp()
    audioPlayer = SCAudioStream()
    audioPlayer.volume = 0.0
    audioPlayer.bufferDuration = 0.001
    listener = SCAudioStreamEventListener(audioPlayer: audioPlayer)
  }

  override func tearDown() {
    audioPlayer = nil
    listener = nil
    super.tearDown()
  }

  func test_AudioPlayer__state__should_be_idle() {
    XCTAssert(audioPlayer.playerState == AudioPlayerState.idle)
  }

  func test_AudioPlayer__state__load_source__should_be_loading() {
    let audioItem = Source.getAudioItem(for: audioItemPath())
    try? audioPlayer.load(item: audioItem, playWhenReady: false)
    XCTAssertEqual(audioPlayer.playerState, AudioPlayerState.loading)
  }

  func test_AudioPlayer__state__load_source__should_be_ready() {
    let expectation = XCTestExpectation()
    listener.stateUpdate = { state in
      switch state {
      case .ready: expectation.fulfill()
      default: break
      }
    }
    try? audioPlayer.load(item: Source.getAudioItem(for: audioItemPath()), playWhenReady: false)
    wait(for: [expectation], timeout: 20.0)
  }

  func test_AudioPlayer__state__load_source_playWhenReady__should_be_playing() {
    let expectation = XCTestExpectation()
    listener.stateUpdate = { state in
      switch state {
      case .playing: expectation.fulfill()
      default: break
      }
    }
    let audioItem = Source.getAudioItem(for: audioItemPath())
    try? audioPlayer.load(item: audioItem, playWhenReady: true)
    wait(for: [expectation], timeout: 20.0)
  }

  func test_AudioPlayer__state__play_source__should_be_playing() {
    let expectation = XCTestExpectation()
    listener.stateUpdate = { state in
      switch state {
      case .ready: self.audioPlayer.play()
      case .playing: expectation.fulfill()
      default: break
      }
    }
    let audioItem = Source.getAudioItem(for: audioItemPath())
    try? audioPlayer.load(item: audioItem, playWhenReady: false)
    wait(for: [expectation], timeout: 20.0)
  }

  func test_AudioPlayer__state__pausing_source__should_be_paused() {
    let expectation = XCTestExpectation()
    listener.stateUpdate = { [weak audioPlayer] state in
      switch state {
      case .playing: audioPlayer?.pause()
      case .paused: expectation.fulfill()
      default: break
      }
    }
    let audioItem = Source.getAudioItem(for: audioItemPath())
    try? audioPlayer.load(item: audioItem, playWhenReady: true)
    wait(for: [expectation], timeout: 20.0)
  }

  func test_AudioPlayer__state__stopping_source__should_be_idle() {
    let expectation = XCTestExpectation()
    var hasBeenPlaying: Bool = false
    listener.stateUpdate = { [weak audioPlayer] state in
      switch state {
      case .playing:
        hasBeenPlaying = true
        audioPlayer?.stop()
      case .idle:
        if hasBeenPlaying {
          expectation.fulfill()
        }
      default: break
      }
    }
    let audioItem = Source.getAudioItem(for: audioItemPath())
    try? audioPlayer.load(item: audioItem, playWhenReady: true)
    wait(for: [expectation], timeout: 20.0)
  }

  // MARK: - Current item
  
  func test_AudioPlayer__currentItem__should_be_nil() {
      XCTAssertNil(audioPlayer.currentItem)
  }
  
  func test_AudioPlayer__currentItem__loading_source__should_not_be_nil() {
      let expectation = XCTestExpectation()
      listener.stateUpdate = { [weak audioPlayer] state in
          guard let audioPlayer = audioPlayer else { return }
          switch state {
          case .ready:
              if audioPlayer.currentItem != nil {
                  expectation.fulfill()
              }
          default: break
          }
      }
      let audioItem = Source.getAudioItem(for: audioItemPath())
      try? audioPlayer.load(item: audioItem, playWhenReady: true)
      wait(for: [expectation], timeout: 20.0)
  }
  
}
