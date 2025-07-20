import AVFoundation
import AudioToolbox

class SoundManager: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var isEnabled = true
    
    init() {
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio setup error: \(error)")
            isEnabled = false
        }
    }
    
    func playPaddleHit() {
        playTone(frequency: 600, duration: 0.05)
    }
    
    func playWallHit() {
        playTone(frequency: 800, duration: 0.05)
    }
    
    func playScore() {
        playTone(frequency: 440, duration: 0.2)
    }
    
    func playWin() {
        playTone(frequency: 523, duration: 0.5)
    }
    
    private func playTone(frequency: Double, duration: Double) {
        guard isEnabled else { return }
        
        #if os(iOS)
        // Use haptic feedback on iOS
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
        
        // Create a simple tone using AVAudioEngine
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        let frameCount = AVAudioFrameCount(duration * audioFormat.sampleRate)
        
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCount) else { return }
        audioBuffer.frameLength = frameCount
        
        let amplitude: Float = 0.1
        let angularFrequency = Float(2 * Double.pi * frequency / audioFormat.sampleRate)
        
        for frame in 0..<Int(frameCount) {
            let sampleValue = amplitude * sinf(angularFrequency * Float(frame))
            audioBuffer.floatChannelData?[0][frame] = sampleValue
        }
        
        let playerNode = AVAudioPlayerNode()
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        
        do {
            if !audioEngine.isRunning {
                try audioEngine.start()
            }
            playerNode.scheduleBuffer(audioBuffer, at: nil, options: [], completionHandler: {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.1) {
                    playerNode.stop()
                    self.audioEngine.detach(playerNode)
                }
            })
            playerNode.play()
        } catch {
            print("Audio playback error: \(error)")
        }
    }
}