//
//  SRLoadingHudView.swift
//  SRLoadingHudView
//
//  Created by 潘东 on 2016/9/28.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit

let BallRadiusDefalut: CGFloat = 20
let IsShowBlur: Bool = true

class SRLoadingHudView: UIView, CAAnimationDelegate {
    //MARK: - Init Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        getBallConf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method and Property
    
    /**
     *
     *  - ballColor: 小球颜色，默认黑色
     *
     */
    public var ballColor: UIColor {
        get {
            guard ball1.backgroundColor != nil else {
                return UIColor.black
            }
            return ball1.backgroundColor!
        }
        set {
            ball1.backgroundColor = newValue
        }
    }
    
    /**
     *
     *  - ballRadius: 小球半径，默认20
     *
     */
    public var ballRadius: CGFloat = BallRadiusDefalut {
        didSet {
            showHud()
        }
    }
    
    /**
     *
     *  - showBlur: 背景毛玻璃效果，默认显示
     *
     */
    public var showBlur: Bool = true {
        didSet {
            showBackgroundBlur()
        }
    }
    
    /**
     *  Show the hud
     *  - parameter: nil
     *  - returns: nil
     *
     */
    public func showHud() {
        if alreadyShowed == false {
            setBall()
            showBackgroundBlur()
            addBall()
            rotationAnimation()
        }
        alreadyShowed = true
    }
    
    /**
     *  Dismiss the hud
     *  - parameter: nil
     *  - returns: nil
     *
     */
    public func dismissHud() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.ball1.alpha = 0
            self.ball2.alpha = 0
            self.ball3.alpha = 0
        }) { (finished) in
            self.isHide = true
            self.alreadyShowed = false
            self.ball1.layer.removeAllAnimations()
            self.ball2.layer.removeAllAnimations()
            self.ball3.layer.removeAllAnimations()
            self.ball1.removeFromSuperview()
            self.ball2.removeFromSuperview()
            self.ball3.removeFromSuperview()
            self.hideBackgroupBlur()
        }
    }
    
    //MARK: - Privare method
    private func getBallConf() {
        Height = self.frame.size.height
        Width = self.frame.size.width
        ballH = Height! / 2 - ballRadius * 0.5
    }
    
    private func setBall() {
        isHide = false
        
        ball1.frame = CGRect(x: Width! / 2 - ballRadius * 1.5, y: ballH!, width: ballRadius, height: ballRadius)
        ball1.layer.cornerRadius = ballRadius / 2
        ball1.backgroundColor = self.ballColor
        ball1.alpha = 1
        
        ball2.frame = CGRect(x: Width! / 2 - ballRadius * 0.5, y: ballH!, width: ballRadius, height: ballRadius)
        ball2.layer.cornerRadius = ballRadius / 2
        ball2.backgroundColor = self.ballColor
        ball2.alpha = 1
        
        ball3.frame = CGRect(x: Width! / 2 + ballRadius * 0.5, y: ballH!, width: ballRadius, height: ballRadius)
        ball3.layer.cornerRadius = ballRadius / 2
        ball3.backgroundColor = self.ballColor
        ball3.alpha = 1
    }
    
    private func addBall() {
        self.addSubview(ball1)
        self.addSubview(ball2)
        self.addSubview(ball3)
    }
    
    private func rotationAnimation() {
        // 1.1 取得围绕中心轴的点
        let centerPoint = CGPoint(x: Width! / 2, y: Height! / 2)
        // 1.2 获得第一个圆的中点
        let centerBall_1 = CGPoint(x: Width! / 2 - ballRadius, y: Height! / 2)
        // 1.3 获得第三个圆的中点
        let centerBall_2 = CGPoint(x: Width! / 2 + ballRadius, y: Height! / 2)
        
        // 2.1 第一个圆的曲线
        let path_ball_1 = UIBezierPath()
        path_ball_1.move(to: centerBall_1)
        
        path_ball_1.addArc(withCenter: centerPoint, radius: ballRadius, startAngle: CGFloat(M_PI), endAngle: 2 * CGFloat(M_PI), clockwise: false)
        let path_ball_1_1 = UIBezierPath()
        path_ball_1_1.addArc(withCenter: centerPoint, radius: ballRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        path_ball_1.append(path_ball_1_1)
        
        // 2.2 第一个圆的动画
        let animation_ball_1 = CAKeyframeAnimation(keyPath: "position")
        animation_ball_1.path = path_ball_1.cgPath
        animation_ball_1.isRemovedOnCompletion = false
        animation_ball_1.fillMode = kCAFillModeForwards
        animation_ball_1.calculationMode = kCAAnimationCubic
        animation_ball_1.repeatCount = 1
        animation_ball_1.duration = 1.4
        animation_ball_1.delegate = self
        animation_ball_1.autoreverses = false
        animation_ball_1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.ball1.layer.add(animation_ball_1, forKey: "animation")
        
        // 2.1 第三个圆的曲线
        let path_ball_3 = UIBezierPath()
        path_ball_3.move(to: centerBall_2)
        
        path_ball_3.addArc(withCenter: centerPoint, radius: ballRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        let path_ball_3_1 = UIBezierPath()
        path_ball_3_1.addArc(withCenter: centerPoint, radius: ballRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(2 * M_PI), clockwise: false)
        path_ball_3.append(path_ball_3_1)
        
        // 2.2 第三个圆的动画
        let animation_ball_3 = CAKeyframeAnimation(keyPath: "position")
        animation_ball_3.path = path_ball_3.cgPath
        animation_ball_3.isRemovedOnCompletion = false
        animation_ball_3.fillMode = kCAFillModeForwards
        animation_ball_3.calculationMode = kCAAnimationCubic
        animation_ball_3.repeatCount = 1
        animation_ball_3.duration = 1.4
        animation_ball_3.autoreverses = false
        animation_ball_3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.ball3.layer.add(animation_ball_3, forKey: "rotation")
    }
    
    private func showBackgroundBlur() {
        guard showBlur == true else {
            bgView.removeFromSuperview()
            return
        }
        self.backgroundColor = UIColor.clear
        bgView.effect = UIBlurEffect(style: .light)
        bgView.alpha = 0.9
        bgView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        bgView.layer.cornerRadius = ballRadius / 2
        bgView.clipsToBounds = true
        self.addSubview(bgView)
    }
    
    private func hideBackgroupBlur() {
        bgView.removeFromSuperview()
    }
    
    //MARK: -  Delegate
    func animationDidStart(_ anim: CAAnimation) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.ball1.transform = CGAffineTransform(translationX: -self.ballRadius, y: 0)
            self.ball1.transform.scaledBy(x: 0.7, y: 0.7)
            
            self.ball3.transform = CGAffineTransform(translationX: self.ballRadius, y: 0)
            self.ball3.transform.scaledBy(x: 0.7, y: 0.7)
            
            self.ball2.transform.scaledBy(x: 0.7, y: 0.7)
            
        }) { (finished) in
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .beginFromCurrentState], animations: {
                self.ball1.transform = CGAffineTransform.identity
                self.ball3.transform = CGAffineTransform.identity
                self.ball2.transform = CGAffineTransform.identity
                }, completion: nil)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished: Bool) {
        if isHide == false {
            self.rotationAnimation()
        }
    }
    
    //MARK: - Setter and Getter
    var ballH: CGFloat?
    var Height: CGFloat?
    var Width: CGFloat?
    
    private var alreadyShowed = false
    private var isHide = false
    private var ball1 = UIView()
    private var ball2 = UIView()
    private var ball3 = UIView()
    private let bgView = UIVisualEffectView()
}
