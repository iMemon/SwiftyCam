/*Copyright (c) 2016, Andrew Walz.
 
 */


import UIKit

//MARK: Public Protocol Declaration

/// Delegate for SwiftyCamButton

public protocol SwiftyCamButtonDelegate: class {
    
    
    
    
    
    /// Called when UITapGestureRecognizer begins
    
    func buttonWasTapped()
    
    /// Called When UILongPressGestureRecognizer enters UIGestureRecognizerState.began
    
    func buttonDidBeginLongPress()
    
    /// Called When UILongPressGestureRecognizer enters UIGestureRecognizerState.end
    
    func buttonDidEndLongPress()
    
    /// Called when the maximum duration is reached
    
    func longPressDidReachMaximumDuration()
    
    /// Sets the maximum duration of the video recording
    
    func setMaxiumVideoDuration() -> Double
}

// MARK: Public View Declaration


/// UIButton Subclass for Capturing Photo and Video with SwiftyCamViewController

open class SwiftyCamButton: UIButton {
    
    
    var    longGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SwiftyCamButton.LongPress))
    
    public   var isVideoBlock : Bool = false
    
    
    /// Delegate variable
    
    public weak var delegate: SwiftyCamButtonDelegate?
    
    /// Maximum duration variable
    
    fileprivate var timer : Timer?
    
    /// Initialization Declaration
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createGestureRecognizers()
    }
    
    /// Initialization Declaration
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createGestureRecognizers()
    }
    
    /// UITapGestureRecognizer Function
    
    @objc fileprivate func Tap() {
        delegate?.buttonWasTapped()
    }
    
    /// UILongPressGestureRecognizer Function
    @objc fileprivate func LongPress(_ sender:UILongPressGestureRecognizer!)  {
        switch sender.state {
        case .began:
            if isVideoBlock == false
            {
                delegate?.buttonDidBeginLongPress()
                startTimer()
            }else  { break }
            
            
            
        case .ended:
            invalidateTimer()
            delegate?.buttonDidEndLongPress()
        default:
            break
        }
    }
    
    /// Timer Finished
    
    @objc fileprivate func timerFinished() {
        invalidateTimer()
        delegate?.longPressDidReachMaximumDuration()
    }
    
    /// Start Maximum Duration Timer
    
    fileprivate func startTimer() {
        if let duration = delegate?.setMaxiumVideoDuration() {
            //Check if duration is set, and greater than zero
            if duration != 0.0 && duration > 0.0 {
                timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector:  #selector(SwiftyCamButton.timerFinished), userInfo: nil, repeats: false)
            }
        }
    }
    
    // End timer if UILongPressGestureRecognizer is ended before time has ended
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    public func setVideoMakingOption(enabllity isEnable: Bool)
    {
        isVideoBlock = isEnable
        (isVideoBlock  == true) ? self.removeLongGesture() :  self.addLongGesturess()
    }
    // Add Tap and LongPress gesture recognizers
    
    fileprivate func createGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SwiftyCamButton.Tap))
        self.addGestureRecognizer(tapGesture)
        
        if !isVideoBlock
        {
            self.addLongGesturess()
        }
    }
    
    fileprivate   func   removeLongGesture ()
    {
        /*
         if (self.checkIfGestureAlreadyPresent(longGesture)) {
         self.removeGestureRecognizer(longGesture) }
         */
    }
    fileprivate  func   addLongGesturess ()
    {
        //   if (self.checkIfGestureAlreadyPresent(longGesture) == false ) {
        
        let longGesture  = UILongPressGestureRecognizer(target: self, action: #selector(SwiftyCamButton.LongPress))
        self.addGestureRecognizer(longGesture)
        //  }
    }
    
    fileprivate   func checkIfGestureAlreadyPresent(_ gesture : UIGestureRecognizer?) -> Bool
    {
        if( gesture == nil )  { return false }
        // If any gesture recogniser is added to the view (change view to any view you want to test)
        if let recognizers = self.gestureRecognizers {
            for gr in recognizers {
                if     gr == gesture {
                    return true
                }
            }
        }
        return false
    }
}

