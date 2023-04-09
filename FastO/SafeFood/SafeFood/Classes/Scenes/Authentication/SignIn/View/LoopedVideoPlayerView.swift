import UIKit
import AVKit

final class LoopedVideoPlayerView: UIView {
    
    // MARK: - Private Variable
    
    private var queuePlayer: AVQueuePlayer?
    private var playerLayer: AVPlayerLayer?
    private var playbackLooper: AVPlayerLooper?
    
    // MARK: - Public
    
    func prepareVideo(_ videoURL: URL) {
        
        let playerItem = AVPlayerItem(url: videoURL)
        
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: queuePlayer)
        guard let playerLayer = self.playerLayer else { return }
        guard let queuePlayer = self.queuePlayer else { return }
        playbackLooper = AVPlayerLooper.init(player: queuePlayer, templateItem: playerItem)
        
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.frame
        layer.addSublayer(playerLayer)
    }
    
    func play() {
        queuePlayer?.play()
    }
    
    func pause() {
        queuePlayer?.pause()
    }
    
    func stop() {
        queuePlayer?.pause()
        queuePlayer?.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1))
    }
    
    func destroy() {
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        queuePlayer = nil
        playbackLooper = nil
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        playerLayer?.frame = self.bounds
    }
}
