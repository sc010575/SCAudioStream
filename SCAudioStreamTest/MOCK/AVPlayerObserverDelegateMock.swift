//
//  AVPlayerObserverDelegateMock.swift
//  SCAudioStreamTest
//
//  Created by Suman Chatterjee on 24/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import AVFoundation
@testable import SCAudioStream

class AVPlayerObserverDelegateMock: AVPlayerObserverDelegate {

  var statusUpdate: ((_ state: AVPlayer.Status) -> Void)?
  var timeControlStatusUpdate: ((_ state: AVPlayer.TimeControlStatus) -> Void)?
  var status: AVPlayer.Status?
  var timeControlStatus: AVPlayer.TimeControlStatus?
  func player(statusDidChange status: AVPlayer.Status) {
    self.status = status
    statusUpdate?(status)
  }

  func player(didChangeTimeControlStatus status: AVPlayer.TimeControlStatus) {
    self.timeControlStatus = status
    timeControlStatusUpdate?(status)
  }
}


