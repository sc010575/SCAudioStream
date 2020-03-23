//
//  AVPlayerWrapperDelegate.swift
//  SCAudioStream
//
//  Created by Suman Chatterjee on 22/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

protocol AVPlayerWrapperDelegate: class {

  func AVWrapper(didChangeState state: AVPlayerWrapperState)
  func AVWrapper(failedWithError error: Error?)
  func AVWrapper(seekTo seconds: Int, didFinish: Bool)
  func AVWrapper(secondsElapsed seconds: Double)
  func AVWrapper(didUpdateDuration duration: Double)
  func AVWrapperItemDidPlayToEndTime()
  func AVWrapperDidRecreateAVPlayer()

}
