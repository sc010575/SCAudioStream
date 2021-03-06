# SCAudioStream

SCAudioStream is an audio player static library, written in Swift 5 , making it simpler to work with simple audio playback from streams and files. Currently supported only a single audio file at a time.

## Example (AudioStream)
To see the audio player in action, run the example project - AudioStream!

## Requirements
iOS 12.0+, Swift 5

## Installation
Clone the repo SCAudioStream. 
To run the example project, clone the repo, and run `pod install` from the AudioStream directory first.

## Usage

### AudioPlayer
To get started playing some audio:
```swift
let player = SCAudioStream()
let audioItem = DefaultAudioItem(audioUrl: "someUrl", sourceType: .stream)
try? player.load(item: audioItem, playWhenReady: true) // Load the item and start playing when the player is ready.
```

To listen for events in the `AudioPlayer`, subscribe to events found in the `event` property of the `SCAudioStream`.
To subscribe to an event:
```swift
class ViewController: UIViewController {

    let player = SCAudioStream()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.event.stateChange.addListener(self, handleAudioPlayerStateChange)
    }
    
    func handleAudioPlayerStateChange(state: AudioPlayerState) {
        // Handle the event
    }
}
```

### Audio Session
Remember to activate an audio session with an appropriate category for your app. This can be done with `AudioSessionController`:
```swift
try? AudioSessionController.shared.set(category: .playback)
//...
// You should wait with activating the session until you actually start playback of audio.
// This is to avoid interrupting other audio without the need to do it.
try? AudioSessionController.shared.activateSession()
```


## Author

Suman Chatterjee
