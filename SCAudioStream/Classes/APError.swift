//
//  APError.swift
//  SCAudioStream
//
//  Created by Suman Chatterjee on 22/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

public struct APError {

  enum LoadError: Error {
    case invalidSourceUrl(String)
  }

  enum PlaybackError: Error {
    case itemNotLoaded
  }
}
