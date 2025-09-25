import AVFoundation
import SwiftUI

final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    var bgPlayer: AVAudioPlayer?
    
    
    @Published var backgroundVolume: Float = 1 {
        didSet {
            bgPlayer?.volume = backgroundVolume
        }
    }
    
    @Published var isSoundEnabled: Bool = true
    @AppStorage("isMusicEnabled") var isMusicEnabled: Bool = false
    
    init() {
        loadBackgroundMusic()
        
        if isMusicEnabled {
            playBackgroundMusic()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func appWillResignActive() {
        stopBackgroundMusic()
    }
    
    @objc private func appDidBecomeActive() {
        if isMusicEnabled {
            playBackgroundMusic()
        }
    }
    
    private func loadBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "music", withExtension: "mp3") {
            do {
                bgPlayer = try AVAudioPlayer(contentsOf: url)
                bgPlayer?.numberOfLoops = -1
                bgPlayer?.volume = backgroundVolume
                bgPlayer?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    
    func playBackgroundMusic() {
        if isMusicEnabled {
            bgPlayer?.play()
        }
    }
    
    func stopBackgroundMusic() {
        bgPlayer?.stop()
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
    }
    
    func toggleMusic() {
        isMusicEnabled.toggle()
        if isMusicEnabled {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }
}
