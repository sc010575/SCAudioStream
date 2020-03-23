//
//  AudioSession.swift
//  SCAudioStreamTest
//
//  Created by Suman Chatterjee on 23/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import AVFoundation
@testable import SCAudioStream

class SuccessfulAudioSession: AudioSession {
    
    var category: AVAudioSession.Category = AVAudioSession.Category.playback
    
    var mode: AVAudioSession.Mode = AVAudioSession.Mode.default
    
    var categoryOptions: AVAudioSession.CategoryOptions = []
    
    var availableCategories: [AVAudioSession.Category] = []
    
    var isOtherAudioPlaying: Bool = false
    
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws {}
    
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, policy: AVAudioSession.RouteSharingPolicy, options: AVAudioSession.CategoryOptions) throws {}
    
    func setActive(_ active: Bool) throws {}
    
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws {}

}

class FallibleAudioSession: AudioSession {
    
    var category: AVAudioSession.Category = AVAudioSession.Category.playback
    
    var mode: AVAudioSession.Mode = AVAudioSession.Mode.default
    
    var categoryOptions: AVAudioSession.CategoryOptions = AVAudioSession.CategoryOptions.allowBluetooth
    
    var availableCategories: [AVAudioSession.Category] = []
    
    var isOtherAudioPlaying: Bool = false
    
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws {
        throw AVError(AVError.unknown)
    }
    
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, policy: AVAudioSession.RouteSharingPolicy, options: AVAudioSession.CategoryOptions) throws {
        throw AVError(AVError.unknown)
    }
    
    func setActive(_ active: Bool) throws {
        throw AVError(AVError.unknown)
    }
    
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws {
        throw AVError(AVError.unknown)
    }
    
    
}

