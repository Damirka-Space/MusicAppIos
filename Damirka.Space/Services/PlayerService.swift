//
//  PlayerService.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import AVKit
import Combine
import MediaPlayer

final class PlayerService : AVPlayer, ObservableObject {
    
    private var tracks: [TrackEntity]?
   
    private var timeObserverToken: Any?
    
    private var nowPlayingInfo = [String: Any]()
    
    @Published var currentTimeInSeconds: Double = 0.0
    
    @Published private var albumId = -1
    @Published private var currentIndex = -1
    @Published private var playing = false
    @Published private var showBarView = false;
    
    var observer: NSKeyValueObservation?
    
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
            
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds((self?.currentTime())!)
            
            if(self?.isPlaying() == true) {
                self?.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
            } else {
                self?.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
            }
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.nowPlayingInfo
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
    }
    
    func setPlaylist(tracks: [TrackEntity], id: Int) {
        self.tracks = tracks
        self.albumId = id
    }
    
    
    func setupNotificationView() {
        let track = tracks![currentIndex]
        
        guard let url = URL(string: track.metadataImageUrl) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if error != nil {
                // Handle error
                return
            }
            
            guard let data = data else {
                return
            }
            
            nowPlayingInfo = [String: Any]()
            
            nowPlayingInfo[MPMediaItemPropertyTitle] = track.title
            
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = track.album
            
            nowPlayingInfo[MPMediaItemPropertyArtist] = track.author.joined(separator: ", ")
            
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(currentItem!.duration)
            
            guard let img = UIImage(data: data) else {
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                return
            }
            
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: img.size, requestHandler: { (size) -> UIImage in
                return img
            })
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
        task.resume()
    }
    
    func setupMediaPlayerNotificationView() {
        self.showBarView = true
        
        do {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [self] notification in
                playTrack(track: currentIndex + 1)
            }
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            let _ = try AVAudioSession.sharedInstance().setActive(true)
            
            let commandCenter = MPRemoteCommandCenter.shared()
            
            commandCenter.playCommand.addTarget {
                [unowned self] event in
                self.play()
                return .success
            }
            
            commandCenter.pauseCommand.addTarget {
                [unowned self] event in
                self.pause()
                return .success
            }
            
            commandCenter.previousTrackCommand.addTarget {
                [unowned self] event in
                self.playPrev()
                return .success
            }

            commandCenter.nextTrackCommand.addTarget {
                [unowned self] event in
                self.playNext()
                return .success
            }
            
            setupNotificationView()
            
        } catch let error as NSError {
            print("an error occurred when audio session category.\n \(error)")
        }
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
        
        pause()
        
        let playerItem = AVPlayerItem.init(url: URL(string: tracks![currentIndex].url)!)
        self.replaceCurrentItem(with: playerItem)

        // Register as an observer of the player item's status property
        self.observer = playerItem.observe(\.status, options:  [.new, .old], changeHandler: { [self] (playerItem, change) in
            if playerItem.status == .readyToPlay {
                setupMediaPlayerNotificationView();
                play()
            }
        })
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
