//
//  AVPlayerWrapperState.swift
//  SCAudioStream
//
//  Created by Suman Chatterjee on 22/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

/**
 The current state of the AudioPlayer.
 */
public enum AVPlayerWrapperState: String {
    
    /// An asset is being loaded for playback.
    case loading
    
    /// The current item is loaded, and the player is ready to start playing.
    case ready
    
    /// The current item is playing, but are currently buffering.
    case buffering
    
    /// The player is paused.
    case paused
    
    /// The player is playing.
    case playing
    
    /// No item loaded, the player is stopped.
    case idle
    
}
