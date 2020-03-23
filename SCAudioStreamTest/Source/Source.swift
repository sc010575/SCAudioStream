//
//  Sources.swift
//  SCAudioStream_Tests
//
//  Created by Suman Chatterjee on 22/03/2020.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import SCAudioStream

extension XCTestCase {
  func audioItemPath() -> String {
    let testBundle = Bundle(for: type(of: self))
    let path: String = testBundle.path(forResource: "TestSound", ofType: "m4a")!
    return path
  }
}
class Source {
  static func getAudioItem(for path: String) -> AudioItem {
    return DefaultAudioItem(audioUrl: path, artist: "Artist", title: "Title", albumTitle: "AlbumTitle", sourceType: .file)
  }
}
