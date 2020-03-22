//
//  AudioSession.swift
//  SCAudioStream
//
//  Created by Suman Chatterjee on 22/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import AVFoundation


protocol AudioSession {
    
    var category: AVAudioSession.Category { get }
    
    var mode: AVAudioSession.Mode { get }
    
    var categoryOptions: AVAudioSession.CategoryOptions { get }
    
    var availableCategories: [AVAudioSession.Category] { get }
    
    @available(iOS 10.0, *)
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws
    
    @available(iOS 11.0, *)
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, policy: AVAudioSession.RouteSharingPolicy, options: AVAudioSession.CategoryOptions) throws
    
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws
    
}

extension AVAudioSession: AudioSession {}
