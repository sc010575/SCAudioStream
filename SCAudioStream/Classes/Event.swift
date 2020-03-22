//
//  Event.swift
//  SCAudioStream
//
//  Created by Suman Chatterjee on 22/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

extension SCAudioStream {

  public typealias StateChangeEventData = (AudioPlayerState)
  public typealias FailEventData = (Error?)
  public typealias SeekEventData = (seconds: Int, didFinish: Bool)
  public typealias UpdateDurationEventData = (Double)
  public typealias PlaybackEndEventData = (PlaybackEndedReason)
  public typealias DidRecreateAVPlayerEventData = ()

  public struct EventHolder {

    /**
         Emitted when the `AudioPlayer`s state is changed
         - Important: Remember to dispatch to the main queue if any UI is updated in the event handler.
         */
    public let stateChange: SCAudioStream.Event<StateChangeEventData> = SCAudioStream.Event()

    /**
         Emitted when the player encounters an error. This will ultimately result in the AVPlayer instance to be recreated.
         If this event is emitted, it means you will need to load a new item in some way. Calling play() will not resume playback.
         - Important: Remember to dispatch to the main queue if any UI is updated in the event handler.
         */
    public let fail: SCAudioStream.Event<FailEventData> = SCAudioStream.Event()

    /**
         Emitted when the player is done attempting to seek.
         - Important: Remember to dispatch to the main queue if any UI is updated in the event handler.
         */
    public let seek: SCAudioStream.Event<SeekEventData> = SCAudioStream.Event()

    /**
         Emitted when the player updates its duration.
         - Important: Remember to dispatch to the main queue if any UI is updated in the event handler.
         */
    public let updateDuration: SCAudioStream.Event<UpdateDurationEventData> = SCAudioStream.Event()
    
    /**
      Emitted when the playback of the player, for some reason, has stopped.
      - Important: Remember to dispatch to the main queue if any UI is updated in the event handler.
      */
     public let playbackEnd: SCAudioStream.Event<PlaybackEndEventData> = SCAudioStream.Event()

    /**
         Emitted when the underlying AVPlayer instance is recreated. Recreation happens if the current player fails.
         - Important: Remember to dispatch to the main queue if any UI is updated in the event handler.
         - Note: It can be necessary to set the AVAudioSession's category again when this event is emitted.
         */
    public let didRecreateAVPlayer: SCAudioStream.Event<()> = SCAudioStream.Event()

  }

  public typealias EventClosure<EventData> = (EventData) -> Void

  class Invoker<EventData> {

    // Signals false if the listener object is nil
    let invoke: (EventData) -> Bool
    weak var listener: AnyObject?

    init<Listener: AnyObject>(listener: Listener, closure: @escaping EventClosure<EventData>) {
      self.listener = listener
      self.invoke = { [weak listener] (data: EventData) in
        guard let _ = listener else {
          return false
        }
        closure(data)
        return true
      }
    }

  }

  public class Event<EventData> {

    private let eventQueue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
    private let actionQueue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
    private let invokersSemaphore: DispatchSemaphore = DispatchSemaphore(value: 1)

    var invokers: [Invoker<EventData>] = []

    public func addListener<Listener: AnyObject>(_ listener: Listener, _ closure: @escaping EventClosure<EventData>) {
      actionQueue.async {
        self.invokersSemaphore.wait()
        self.invokers.append(Invoker(listener: listener, closure: closure))
        self.invokersSemaphore.signal()
      }
    }

    public func removeListener(_ listener: AnyObject) {
      actionQueue.async {
        self.invokersSemaphore.wait()
        self.invokers = self.invokers.filter({ (invoker) -> Bool in
          if let listenerToCheck = invoker.listener {
            return listenerToCheck !== listener
          }
          return true
        })
        self.invokersSemaphore.signal()
      }
    }

    func emit(data: EventData) {
      eventQueue.async {
        self.invokersSemaphore.wait()
        self.invokers = self.invokers.filter({ (invoker) -> Bool in
          return invoker.invoke(data)
        })
        self.invokersSemaphore.signal()
      }
    }

  }

}
