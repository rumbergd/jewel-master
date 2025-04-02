import Foundation
import AVFoundation

class SoundEffects {
    static let shared = SoundEffects()
    private var audioEngine: AVAudioEngine
    private var audioPlayerNode: AVAudioPlayerNode
    private var matchSound: AVAudioPCMBuffer?
    
    private init() {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        setupMatchSound()
    }
    
    private func setupMatchSound() {
        let sampleRate = 44100.0
        let duration = 0.1 // 100ms
        let frequency = 880.0 // A5 note
        
        let frameCount = AVAudioFrameCount(duration * sampleRate)
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        matchSound = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
        matchSound?.frameLength = frameCount
        
        // Generate a simple sine wave
        let buffer = matchSound?.floatChannelData?[0]
        for frame in 0..<Int(frameCount) {
            let value = sin(2.0 * .pi * frequency * Double(frame) / sampleRate)
            buffer?[frame] = Float32(value * 0.5) // Reduce volume to 50%
        }
        
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: format)
        try? audioEngine.start()
    }
    
    func playMatchSound() {
        guard let sound = matchSound else { return }
        audioPlayerNode.scheduleBuffer(sound, at: nil, options: .interrupts, completionHandler: nil)
        audioPlayerNode.play()
    }
}
