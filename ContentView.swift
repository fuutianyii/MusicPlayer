import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isPlaying = false
    @State private var player: AVAudioPlayer?
    @State private var progress: Double = 0.0
    @State private var timer: Timer?

    let songTitle = "示例歌曲"
    let artist = "歌手名"

    var body: some View {
        VStack(spacing: 30) {
            Text(songTitle)
                .font(.title)
                .bold()
            Text(artist)
                .font(.subheadline)
                .foregroundColor(.gray)
            Image(systemName: "music.note")
                .resizable()
                .frame(width: 150, height: 150)
                .padding()
            Slider(value: $progress, in: 0...1, onEditingChanged: sliderChanged)
                .accentColor(.blue)
            HStack(spacing: 40) {
                Button(action: playPause) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
            }
        }
        .padding()
        .onAppear(perform: setupPlayer)
    }

    func setupPlayer() {
        if let url = Bundle.main.url(forResource: "music", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
            } catch {
                print("音频文件加载失败")
            }
        }
    }

    func playPause() {
        guard let player = player else { return }
        if isPlaying {
            player.pause()
            timer?.invalidate()
        } else {
            player.play()
            startTimer()
        }
        isPlaying.toggle()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let player = player {
                progress = player.currentTime / player.duration
                if player.currentTime >= player.duration {
                    isPlaying = false
                    timer?.invalidate()
                }
            }
        }
    }

    func sliderChanged(editing: Bool) {
        guard let player = player else { return }
        if !editing {
            player.currentTime = progress * player.duration
            if isPlaying {
                player.play()
            }
        }
    }
} 