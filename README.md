# SCAudioStream

SCAudioStream is an audio player written in Swift 5 , making it simpler to work with simple audio playback from streams and files.

## Example

To see the audio player in action, run the example project!
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 12.0+

## Installation

### CocoaPods
SwiftAudio is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftAudio', '~> 0.11.2'
```

## Usage

### AudioPlayer
To get started playing some audio:
```swift
let player = SCAudioStream()
let audioItem = DefaultAudioItem(audioUrl: "someUrl", sourceType: .stream)
try? player.load(item: audioItem, playWhenReady: true) // Load the item and start playing when the player is ready.
```

To listen for events in the `AudioPlayer`, subscribe to events found in the `event` property of the `AudioPlayer`.
To subscribe to an event:
```swift
class ViewController: UIViewController {

    let audioPlayer = SCAudioStream()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer.event.stateChange.addListener(self, handleAudioPlayerStateChange)
    }
    
    func handleAudioPlayerStateChange(state: AudioPlayerState) {
        // Handle the event
    }
}
```
