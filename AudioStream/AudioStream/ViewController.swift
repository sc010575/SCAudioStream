//
//  ViewController.swift
//  AudioStream
//
//  Created by Suman Chatterjee on 22/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import UIKit
import SCAudioStream

extension Double {

  private var formatter: DateComponentsFormatter {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    return formatter
  }

  func secondsToString() -> String {
    return formatter.string(from: self) ?? ""
  }

}


class ViewController: UIViewController {
  @IBOutlet weak var artistLabel: UILabel!
  @IBOutlet weak var songTitleLabel: UILabel!
  @IBOutlet weak var prevButton: UIButton!
  @IBOutlet weak var fastButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!

  @IBOutlet weak var elapsedTimeLabel: UILabel!
  @IBOutlet weak var remainingTimeLabel: UILabel!

  @IBOutlet weak var playerItemStackView: UIStackView!
  let player = SCAudioStream()
  let audioSessionController = AudioSessionController.shared
  let source: AudioItem =
    DefaultAudioItem(audioUrl: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", artist: "Bon Iver", title: "33 \"GOD\"", albumTitle: "22, A Million", sourceType: .stream)


  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = "A Simple Audio Player"
    player.event.stateChange.addListener(self, handleAudioPlayerStateChange)
    player.event.fail.addListener(self, handlePlayerFailure)
    player.event.playbackEnd.addListener(self, handlePlayBackEnd)
    player.event.secondElapse.addListener(self, handleAudioPlayerSecondElapsed)
    handleAudioPlayerStateChange(data: .idle)
  }

  deinit {
    player.event.stateChange.removeListener(self)
    player.event.fail.removeListener(self)
    player.event.secondElapse.removeListener(self)
    player.event.playbackEnd.removeListener(self)
  }

  @IBAction func togglePlay(_ sender: Any) {
    if !audioSessionController.audioSessionIsActive {
      try? audioSessionController.set(category: .playback)
      try? audioSessionController.activateSession()
      try? player.load(item: source, playWhenReady: true)
    }
    player.togglePlaying()
  }

  @IBAction func onTapForward(_ sender: Any) {
    player.seek(to: 15)
  }
  @IBAction func onTapRewinds(_ sender: Any) {
    player.seek(to: -15)
  }
  private func setPlayButtonState(forAudioPlayerState state: AudioPlayerState) {
    playButton.setTitle(state == .playing ? "Pause" : "Play", for: .normal)
    prevButton.isHidden = state == .playing ? false : true
    fastButton.isHidden = state == .playing ? false : true
  }

  private func updateTimeValues() {
    elapsedTimeLabel.text = "Elapsed:-\(self.player.currentTime.secondsToString())"
    remainingTimeLabel.text = "Remaining:-\((self.player.duration - self.player.currentTime).secondsToString())"
  }

  private func updateMetaData() {
    if let item = player.currentItem {
      songTitleLabel.text = item.getTitle()
      artistLabel.text = item.getArtist()
    }
  }
// MARK: - AudioPlayer Event Handlers

  func handleAudioPlayerStateChange(data: SCAudioStream.StateChangeEventData) {
    print(data)
    DispatchQueue.main.async {
      var statusTitle = ""
      switch data {
      case .loading:
        statusTitle = "Audio is loading"
        self.updateMetaData()
        self.updateTimeValues()
      case .buffering:
        statusTitle = "Buffering ....."
      case .ready:
        statusTitle = "Ready  to play"
        self.playerItemStackView.isHidden = false
        self.updateMetaData()
        self.updateTimeValues()
      case .playing:
        statusTitle = "Audio playing.."
        self.updateTimeValues()
      case .paused:
        statusTitle = "Audio paused"
        self.updateTimeValues()
      case .idle:
        statusTitle = "Idle.."
        self.playerItemStackView.isHidden = true
      }
      self.statusLabel.text = statusTitle
      self.setPlayButtonState(forAudioPlayerState: data)
    }
  }

  func handleAudioPlayerSecondElapsed(data: SCAudioStream.SecondElapseEventData) {
    DispatchQueue.main.async {
      self.updateTimeValues()
    }
  }

  func handlePlayBackEnd(data: SCAudioStream.PlaybackEndEventData) {
    player.stop()
    audioSessionController.audioSessionIsActive = false
  }
  
  func handlePlayerFailure(data: SCAudioStream.FailEventData) {
    if let error = data as NSError? {
      if error.code == -1009 {
        DispatchQueue.main.async {
          self.statusLabel.text = "Network disconnected. Please try again..."
        }
      }
    }
  }
}
