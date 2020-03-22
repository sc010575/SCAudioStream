//
//  SCAudioStream.swift
//  SCAudioStream
//
//  Created by Suman Chatterjee on 20/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

import MediaPlayer

public typealias AudioPlayerState = AVPlayerWrapperState

public class SCAudioStream: AVPlayerWrapperDelegate {

  private var _wrapper: AVPlayerWrapperProtocol

  /// The wrapper around the underlying AVPlayer
  var wrapper: AVPlayerWrapperProtocol {
    return _wrapper
  }

  public let event = EventHolder()

  var _currentItem: AudioItem?
  public var currentItem: AudioItem? {
    return _currentItem
  }

  // MARK: - Getters from AVPlayerWrapper

  /**
     The elapsed playback time of the current item.
     */
  public var currentTime: Double {
    return wrapper.currentTime
  }

  /**
     The duration of the current AudioItem.
     */
  public var duration: Double {
    return wrapper.duration
  }

  /**
     The bufferedPosition of the current AudioItem.
     */
  public var bufferedPosition: Double {
    return wrapper.bufferedPosition
  }

  /**
     The current state of the underlying `AudioPlayer`.
     */
  public var playerState: AudioPlayerState {
    return wrapper.state
  }

  // MARK: - Setters for AVPlayerWrapper

  /**
     The amount of seconds to be buffered by the player. Default value is 0 seconds.
          
     */
  public var bufferDuration: TimeInterval {
    get { return wrapper.bufferDuration }
    set { _wrapper.bufferDuration = newValue }
  }

  /**
     Set this to decide how often the player should call the delegate with time progress events.
     */
  public var timeEventFrequency: TimeEventFrequency {
    get { return wrapper.timeEventFrequency }
    set { _wrapper.timeEventFrequency = newValue }
  }

  public var volume: Float {
    get { return wrapper.volume }
    set { _wrapper.volume = newValue }
  }

  public var isMuted: Bool {
    get { return wrapper.isMuted }
    set { _wrapper.isMuted = newValue }
  }

  public var rate: Float {
    get { return wrapper.rate }
    set { _wrapper.rate = newValue }
  }

  // MARK: - Init

  /**
      Create a new AudioPlayer.
      */
  public init() {
    self._wrapper = AVPlayerWrapper()
    self._wrapper.delegate = self
  }

  // MARK: - Player Actions

  /**
     Load an AudioItem into the manager.
     
     - parameter item: The AudioItem to load. The info given in this item is the one used for the InfoCenter.
     - parameter playWhenReady: Immediately start playback when the item is ready. Default is `true.
     */
  public func load(item: AudioItem, playWhenReady: Bool = true) throws {
    let url: URL
    switch item.getSourceType() {
    case .stream:
      if let itemUrl = URL(string: item.getSourceUrl()) {
        url = itemUrl
      }
      else {
        throw APError.LoadError.invalidSourceUrl(item.getSourceUrl())
      }
    case .file:
      url = URL(fileURLWithPath: item.getSourceUrl())
    }


    wrapper.load(from: url,
      playWhenReady: playWhenReady, initialTime: (item as? InitialTiming)?.getInitialTime(),
      options: (item as? AssetOptionsProviding)?.getAssetOptions())

    self._currentItem = item

  }
  /**
     Toggle playback status.
     */
  public func togglePlaying() {
    self.wrapper.togglePlaying()
  }

  /**
     Start playback
     */
  public func play() {
    self.wrapper.play()
  }

  /**
     Pause playback
     */
  public func pause() {
    self.wrapper.pause()
  }

  /**
     Stop playback, resetting the player.
     */
  public func stop() {
    self.reset()
    self.wrapper.stop()
  }

  /**
     Seek to a specific time in the item.
     */
  public func seek(to seconds: TimeInterval) {
    self.wrapper.seek(to: seconds)
  }


  // MARK: - Private

  func reset() {
    self._currentItem = nil
  }


  // MARK: - AVPlayerWrapperDelegate

  func AVWrapper(didChangeState state: AVPlayerWrapperState) {
    self.event.stateChange.emit(data: state)
    switch state {
    case .ready, .loading:
      print(state)
    case .playing, .paused:
      print(state)
    default: break
    }
  }

  func AVWrapper(failedWithError error: Error?) {
    self.event.fail.emit(data: error)
  }

  func AVWrapper(seekTo seconds: Int, didFinish: Bool) {
    self.event.seek.emit(data: (seconds, didFinish))
  }

  func AVWrapper(didUpdateDuration duration: Double) {
    self.event.updateDuration.emit(data: duration)
  }

  func AVWrapperItemDidPlayToEndTime() {
    self.event.playbackEnd.emit(data: .playedUntilEnd)
  }

  func AVWrapperDidRecreateAVPlayer() {
    self.event.didRecreateAVPlayer.emit(data: ())
  }

}
