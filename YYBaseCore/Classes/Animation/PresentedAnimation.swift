//
//  PresentedAnimation.swift
//  Core
//
//  Created by Chris on 2021/11/3.
//

import Foundation

open class PresentedAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    /// 当前状态是否为 presented, 默认是 true ( 如果是false, 那就是 dismiss )
    open var presented: Bool = true
    /// 当前 presented 的类型, 默认从中间显示
    open var presentedStyle: PresentedStyle = .center
    /// 需要动画操作的模态视图
    open var presentedView: UIView? = nil
    /// presented 动画时间
    open var presentedDuration: Double = 0
    /// dismiss 动画时间
    open var dismissDuration: Double = 0
    
    public init(presented: Bool,
         presentedView: UIView,
         presentedStyle: PresentedStyle = .center,
         presentedDuration: Double = 0.15,
         dismissDuration: Double = 0.1) {
        super.init()
        self.presented = presented
        self.presentedView = presentedView
        self.presentedStyle = presentedStyle
        self.presentedDuration = presentedDuration
        self.dismissDuration = dismissDuration
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if presented {
            return presentedDuration
        }
        return dismissDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presented {
            guard let toController = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            
            let containerView = transitionContext.containerView
            containerView.addSubview(toController.view)
            
            presentedAnimation(with: toController, transitionDuration(using: transitionContext)) { finished in
                transitionContext.completeTransition(finished)
            }
        }else {
            guard let fromController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }
            
            dismissAnimation(with: fromController, transitionDuration(using: transitionContext)) { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
    
    /// presented 动画
    open func presentedAnimation(with toController: UIViewController, _ duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        
        toController.view.alpha = 0
        
        switch presentedStyle {
        case .center:
            
            self.presentedView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
                toController.view.alpha = 1
                self.presentedView?.transform = .identity
            } completion: { _ in
                if let completion = completion {
                    completion(true)
                }
            }
        case .bottom:
            
            self.presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: -1)
            
            UIView.animate(withDuration: duration) {
                toController.view.alpha = 1
                self.presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            } completion: { _ in
                if let completion = completion {
                    completion(true)
                }
            }
        }
    }
    
    /// dimiss 动画
    open func dismissAnimation(with fromController: UIViewController, _ duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        
        switch presentedStyle {
        case .center:
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
                fromController.view.alpha = 0
                self.presentedView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } completion: { _ in
                if let completion = completion {
                    completion(true)
                }
            }
        case .bottom:
            
            UIView.animate(withDuration: duration) {
                fromController.view.alpha = 0
                self.presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: -1)
            } completion: { _ in
                if let completion = completion {
                    completion(true)
                }
            }
        }
    }
}

public enum PresentedStyle {
    case center
    case bottom
}
