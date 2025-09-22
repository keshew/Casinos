import AVFoundation
import Foundation

final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var players: [String: AVAudioPlayer] = [:]
    @Published var isMuted: Bool = false

    private init() { }

    func play(_ name: String, ext: String = "mp3", volume: Float = 0.8) {
        guard !isMuted else { return }
        let key = name + "." + ext
        if let player = players[key] {
            player.currentTime = 0
            player.volume = volume
            player.play()
            return
        }
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            player.play()
            players[key] = player
        } catch {
            // ignore
        }
    }
}


