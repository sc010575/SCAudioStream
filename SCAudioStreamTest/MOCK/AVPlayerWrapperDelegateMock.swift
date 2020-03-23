//
//  AVPlayerWrapperDelegateMock.swift
//  SCAudioStreamTest
//
//  Created by Suman Chatterjee on 23/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import AVFoundation
import XCTest
@testable import SCAudioStream

class AVPlayerWrapperDelegateMock: AVPlayerWrapperDelegate {
    func AVWrapperDidRecreateAVPlayer() {
        
    }
    
    func AVWrapperItemDidPlayToEndTime() {
        
    }
    
    var state: AVPlayerWrapperState? {
        didSet {
            if let state = state {
                self.stateUpdate?(state)
            }
        }
    }
    
    var stateUpdate: ((_ state: AVPlayerWrapperState) -> Void)?
    var didUpdateDuration: ((_ duration: Double) -> Void)?
    var didSeekTo: ((_ seconds: Int) -> Void)?
    var itemDidComplete: (() -> Void)?
    
    func AVWrapper(didChangeState state: AVPlayerWrapperState) {
        self.state = state
    }
    
    func AVWrapper(secondsElapsed seconds: Double) {
        
    }
    
    func AVWrapper(failedWithError error: Error?) {
        
    }
    
    func AVWrapper(seekTo seconds: Int, didFinish: Bool) {
         didSeekTo?(seconds)
    }
    
    func AVWrapper(didUpdateDuration duration: Double) {
        if let state = self.state {
            self.stateUpdate?(state)
        }
        didUpdateDuration?(duration)
    }
    
}
