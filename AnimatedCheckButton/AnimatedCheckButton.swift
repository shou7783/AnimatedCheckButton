//
//  AnimatedCheckButton.swift
//  AnimatedCheckButton
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 MengHsiu Chang
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

public class AnimatedCheckButton: UIButton {
    
    // Public Property
    public var duration: Double = 0.5
    public var circleAlpha: CGFloat = 0.2 {
        didSet {
            circleLayer.strokeColor = self.color.colorWithAlphaComponent(circleAlpha).CGColor
        }
    }
    
    public var color: UIColor = UIColor.blueColor() {
        didSet {
            circleLayer.strokeColor = color.colorWithAlphaComponent(self.circleAlpha).CGColor
            animatedLayer.strokeColor = color.CGColor
        }
    }
    
    public var lineWidth: CGFloat = 8 {
        didSet {
            circleLayer.lineWidth = lineWidth
            animatedLayer.lineWidth = lineWidth
        }
    }
    
    override public var selected: Bool {
        didSet {
            if selected {
                self.selectAnimation()
            } else {
                self.deselectAnimation()
            }
        }
    }
    
    
    
    var animatedLayer: CAShapeLayer = CAShapeLayer()
    var circleLayer: CAShapeLayer = CAShapeLayer()
    
    private let strokeStart_initValue: CGFloat = 0
    private let strokeStart_completionValue  : CGFloat = 0.815
    private let strokeEnd_initValue: CGFloat = 0.735
    private let strokeEnd_completionValue  : CGFloat = 0.98
    private let animationOffset: CGFloat = 0.02
    
    private var circleSize: CGSize {
        get {
            var newSize = self.frame.size
            if (self.frame.width > self.frame.height) {
                newSize = CGSizeMake(self.frame.height, self.frame.height)
            } else if (frame.width < frame.height) {
                newSize = CGSizeMake(self.frame.width, self.frame.width)
            }
            return newSize
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.color = self.tintColor

        circleLayer.path = UIBezierPath(ovalInRect: self.bounds).CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = self.color.colorWithAlphaComponent(self.circleAlpha).CGColor
        circleLayer.lineWidth = self.lineWidth
        
        animatedLayer.path = self.getAnimatedPath().CGPath
        animatedLayer.fillColor = UIColor.clearColor().CGColor
        animatedLayer.lineJoin = "round"
        animatedLayer.lineCap = "round"
        animatedLayer.strokeEnd = strokeEnd_initValue
        animatedLayer.strokeColor = self.color.CGColor
        animatedLayer.lineWidth = self.lineWidth
        
        self.layer.addSublayer(self.animatedLayer)
        self.layer.addSublayer(self.circleLayer)
        
        self.addTargets()
    }
    
    private func addTargets() {
        //===============
        // add target
        //===============
        self.addTarget(self, action: #selector(AnimatedCheckButton.touchDown(_:)), forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: #selector(AnimatedCheckButton.touchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: #selector(AnimatedCheckButton.touchDragExit(_:)), forControlEvents: UIControlEvents.TouchDragExit)
        self.addTarget(self, action: #selector(AnimatedCheckButton.touchDragEnter(_:)), forControlEvents: UIControlEvents.TouchDragEnter)
        self.addTarget(self, action: #selector(AnimatedCheckButton.touchCancel(_:)), forControlEvents: UIControlEvents.TouchCancel)
    }
    
    func touchDown(sender: AnimatedCheckButton) {
        self.layer.opacity = 0.4
    }
    func touchUpInside(sender: AnimatedCheckButton) {
        self.layer.opacity = 1.0
        self.selected = !self.selected
    }
    func touchDragExit(sender: AnimatedCheckButton) {
        self.layer.opacity = 1.0
    }
    func touchDragEnter(sender: AnimatedCheckButton) {
        self.layer.opacity = 0.4
    }
    func touchCancel(sender: AnimatedCheckButton
        ) {
        self.layer.opacity = 1.0
    }
    
    private func getAnimatedPath() -> UIBezierPath {
        let size = self.circleSize
        let bPath = UIBezierPath(arcCenter: CGPointMake(size.width/2, size.height/2), radius: size.height/2, startAngle: 3.15*CGFloat(M_PI), endAngle: 1.15*CGFloat(M_PI), clockwise: false)
        bPath.addLineToPoint(CGPointMake(size.width*10.5/25, size.height*17/25))
        bPath.addLineToPoint(CGPointMake(size.width*21/25, size.height*7/25))
        return bPath
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.path = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: self.circleSize)).CGPath
        animatedLayer.path = self.getAnimatedPath().CGPath
    }
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let size = self.circleSize
        if (point.x < size.width && point.y < size.height) {
            return true;
        }
        return false;
    }
    
    private func selectAnimation() {
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = strokeStart_initValue
        animation.toValue = strokeStart_completionValue + animationOffset
        animation.duration = self.duration * 0.8
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = strokeEnd_initValue
        endAnimation.toValue = strokeEnd_completionValue + animationOffset
        endAnimation.duration = self.duration * 0.8
        endAnimation.fillMode = kCAFillModeForwards
        endAnimation.removedOnCompletion = false
        
        let sanimation = CABasicAnimation(keyPath: "strokeStart")
        sanimation.beginTime = self.duration * 0.8
        sanimation.fromValue = strokeStart_completionValue + animationOffset
        sanimation.toValue = strokeStart_completionValue
        sanimation.duration = self.duration * 0.2
        sanimation.fillMode = kCAFillModeForwards
        sanimation.removedOnCompletion = false
        
        let eAnimation = CABasicAnimation(keyPath: "strokeEnd")
        eAnimation.beginTime = self.duration * 0.8
        eAnimation.fromValue = strokeEnd_completionValue + animationOffset
        eAnimation.toValue = strokeEnd_completionValue
        eAnimation.duration = self.duration * 0.2
        eAnimation.fillMode = kCAFillModeForwards
        eAnimation.removedOnCompletion = false
        
        let animationGroup = CAAnimationGroup()
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.removedOnCompletion = false
        animationGroup.duration = self.duration;
        animationGroup.animations = [animation, endAnimation, sanimation, eAnimation]
        animationGroup.delegate = self
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        animatedLayer.addAnimation(animationGroup, forKey: "ff")
    }
    
    private func deselectAnimation() {
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = strokeStart_completionValue
        animation.toValue = strokeStart_completionValue + animationOffset
        animation.duration = self.duration * 0.2
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = strokeEnd_completionValue
        endAnimation.toValue = strokeEnd_completionValue + animationOffset
        endAnimation.duration = self.duration * 0.2
        endAnimation.fillMode = kCAFillModeForwards
        endAnimation.removedOnCompletion = false
        
        let sanimation = CABasicAnimation(keyPath: "strokeStart")
        sanimation.beginTime = self.duration * 0.2
        sanimation.fromValue = strokeStart_completionValue + animationOffset
        sanimation.toValue = strokeStart_initValue
        sanimation.duration = self.duration * 0.8
        sanimation.fillMode = kCAFillModeForwards
        sanimation.removedOnCompletion = false
        
        let eAnimation = CABasicAnimation(keyPath: "strokeEnd")
        eAnimation.beginTime = self.duration * 0.2
        eAnimation.fromValue = strokeEnd_completionValue + animationOffset
        eAnimation.toValue = strokeEnd_initValue
        eAnimation.duration = self.duration * 0.8
        eAnimation.fillMode = kCAFillModeForwards
        eAnimation.removedOnCompletion = false
        
        let animationGroup = CAAnimationGroup()
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.removedOnCompletion = false
        animationGroup.duration = self.duration
        animationGroup.animations = [animation, endAnimation, sanimation, eAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationGroup.delegate = self
        
        animatedLayer.addAnimation(animationGroup, forKey: "ff")
    }
    
    override public func animationDidStart(anim: CAAnimation) {
        self.userInteractionEnabled = false
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.userInteractionEnabled = true
    }
    
    
}
