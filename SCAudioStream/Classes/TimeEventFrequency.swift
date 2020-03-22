//
//  TimeEventFrequency.swift
//  SCAudioStream
//
//  Created by Suman Chatterjee on 22/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import AVFoundation


public enum TimeEventFrequency {
    case everySecond
    case everyHalfSecond
    case everyQuarterSecond
    case custom(time: CMTime)
    
    func getTime() -> CMTime {
        switch self {
        case .everySecond: return CMTime(value: 1, timescale: 1)
        case .everyHalfSecond: return CMTime(value: 1, timescale: 2)
        case .everyQuarterSecond: return CMTime(value: 1, timescale: 4)
        case .custom(let time): return time
        }
    }
}
