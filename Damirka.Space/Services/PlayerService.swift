//
//  PlayerService.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import AVKit
import Combine

final class PlayerService : AVPlayer, ObservableObject {
    private var albumId = -1
    private var currentIndex = -1
    private var tracks: [TrackEntity]?
    
    private var playingQueue = AVQueuePlayer()
    
    private var playing = false
    private var showBarView = false;
   
    private var timeObserverToken: Any?
    
    @Published var currentTimeInSeconds: Double = 0.0
    
    var currentTimeInSecondsPass: AnyPublisher<Double, Never>  {
        return $currentTimeInSeconds
            .eraseToAnyPublisher()
    }

    override init() {
        super.init()
        registerObserves()
    }

    private func registerObserves() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = self.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] _ in
            self?.currentTimeInSeconds = self?.currentTime().seconds ?? 0.0
        }
    }
    
    func isNeedShowBarView() -> Bool {
        return showBarView
    }
    
    func isPlaying() -> Bool {
        return playing
    }
    
    func getPlayingTrack() -> TrackEntity {
        return tracks![currentIndex];
    }
    
    func getId() -> Int {
        return albumId
    }
    
    func getPlayingIndex() -> Int {
        return currentIndex
    }

    func rewindTime(to seconds: Double) {
        let timeCM = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.seek(to: timeCM)
    }

    deinit {
        if let token = timeObserverToken {
            self.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    func playPlaylist(tracks: [TrackEntity], id: Int) {
        self.setPlaylist(tracks: tracks, id: id)
        playingQueue.removeAllItems()
    }
    
    func setPlaylist(tracks: [TrackEntity], id: Int) {
        self.tracks = tracks
        self.albumId = id
        showBarView = true
    }

    
    func playTrack(track: Int) {
        if(track >= tracks!.count) {
            currentIndex = 0
        }
        else if(track < 0) {
            currentIndex = tracks!.count - 1
        }
        else {
            currentIndex = track
        }
        
        do {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [self] notification in
                playTrack(track: currentIndex + 1)
            }
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            let _ = try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("an error occurred when audio session category.\n \(error)")
        }
        
        let playerItem = AVPlayerItem.init(url: URL(string: tracks![currentIndex].url)!)
        
        pause()
        
        self.replaceCurrentItem(with: playerItem)
        
        play()
    }
    
    func playNext() {
        playTrack(track: currentIndex + 1)
    }
    
    func playPrev() {
        playTrack(track: currentIndex - 1)
    }
    
    override func play() {
        playing = true
        super.play()
    }
    
    override func pause() {
        playing = false
        super.pause()
    }
}
