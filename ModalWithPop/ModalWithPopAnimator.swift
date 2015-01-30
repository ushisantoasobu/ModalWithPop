//
//  ModalWithPopAnimator.swift
//  ModalWithPop
//
//  Created by SatoShunsuke on 2015/01/31.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit

class ModalWithPopAnimator: NSObject,
    UIViewControllerAnimatedTransitioning,
    POPAnimationDelegate {
   
    let kDuration = 0.28
    let kBackgroundAlpha = 0.3
    
    var isReverse = false
    
    var backgroundView = UIView()
    
    var context:UIViewControllerContextTransitioning?
    
    var startPoint = CGPointZero
    
    override init() {
        super.init()
        
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.alpha = 0.0
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return kDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.context = transitionContext
        
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as UIViewController
        let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as UIViewController
        let container = transitionContext.containerView()
        
        to.view.frame = container.frame //TODO:これはなに？？
        
        if !self.isReverse {
            //表示時
            
            to.view.alpha = 0.0
            backgroundView.alpha = 0.0
            
            self.backgroundView.frame = container.frame //TODO:bounds
            
            container.insertSubview(to.view, aboveSubview: from.view)
            container.insertSubview(self.backgroundView, belowSubview: to.view)
            
            //scale
            var scaleSpringAnimation = POPSpringAnimation()
            scaleSpringAnimation.delegate = self
            scaleSpringAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayerScaleXY) as POPAnimatableProperty
            scaleSpringAnimation.fromValue = NSValue(CGPoint: CGPointMake(0, 0))
            scaleSpringAnimation.toValue = NSValue(CGPoint: CGPointMake(1, 1))
            scaleSpringAnimation.springBounciness = 8
            scaleSpringAnimation.springSpeed = 10
            to.view.layer.pop_addAnimation(scaleSpringAnimation, forKey: "scaleSpringAnimation")
            
            //translation
            var translationBasicAnimation = POPBasicAnimation()
            translationBasicAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayerTranslationXY) as POPAnimatableProperty
            var translationStartPoint = CGPointMake(self.startPoint.x - UIScreen.mainScreen().bounds.width / 2,
                                                    self.startPoint.y - UIScreen.mainScreen().bounds.height / 2)
            translationBasicAnimation.fromValue = NSValue(CGPoint: translationStartPoint)
            translationBasicAnimation.toValue = NSValue(CGPoint: CGPointMake(0, 0))
            translationBasicAnimation.duration = kDuration
            to.view.layer.pop_addAnimation(translationBasicAnimation, forKey: "translationBasicAnimation")
            
            //alpha
            var alphaBasicAnimation = POPBasicAnimation()
            alphaBasicAnimation.property = POPAnimatableProperty.propertyWithName(kPOPViewAlpha) as POPAnimatableProperty
            alphaBasicAnimation.fromValue = 0.0
            alphaBasicAnimation.toValue = 1.0
            alphaBasicAnimation.duration = kDuration //TODO:0.04
            to.view.pop_addAnimation(alphaBasicAnimation, forKey: "alphaBasicAnimation")
            
            var backgroundAlphaBasicAnimation = POPBasicAnimation()
            backgroundAlphaBasicAnimation.property = POPAnimatableProperty.propertyWithName(kPOPViewAlpha) as POPAnimatableProperty
            backgroundAlphaBasicAnimation.fromValue = 0.0
            backgroundAlphaBasicAnimation.toValue = kBackgroundAlpha
            backgroundAlphaBasicAnimation.duration = kDuration
            self.backgroundView.pop_addAnimation(backgroundAlphaBasicAnimation, forKey: "backgroundAlphaBasicAnimation")
            
        } else {
            //消えるとき
            
            to.view.layer.transform = CATransform3DIdentity
            
            self.backgroundView.alpha = CGFloat(kBackgroundAlpha)
            self.backgroundView.frame = container.bounds
            container.insertSubview(to.view, belowSubview: from.view)
            container.insertSubview(self.backgroundView, aboveSubview: to.view)
            
            //scale
            var scaleBasicAnimation = POPBasicAnimation()
            scaleBasicAnimation.delegate = self
            scaleBasicAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayerScaleXY) as POPAnimatableProperty
            scaleBasicAnimation.fromValue = NSValue(CGPoint: CGPointMake(1, 1))
            scaleBasicAnimation.toValue = NSValue(CGPoint: CGPointMake(0, 0))
            from.view.layer.pop_addAnimation(scaleBasicAnimation, forKey: "scaleBasicAnimation")
            
            //translation
            var translationBasicAnimation = POPBasicAnimation()
            translationBasicAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayerTranslationXY) as POPAnimatableProperty
            var translationStartPoint = CGPointMake(self.startPoint.x - UIScreen.mainScreen().bounds.width / 2,
                self.startPoint.y - UIScreen.mainScreen().bounds.height / 2)
            translationBasicAnimation.fromValue = NSValue(CGPoint: CGPointMake(0, 0))
            translationBasicAnimation.toValue = NSValue(CGPoint: translationStartPoint)
            translationBasicAnimation.duration = kDuration
            from.view.layer.pop_addAnimation(translationBasicAnimation, forKey: "translationBasicAnimation")
            
            //alpha
            var alphaBasicAnimation = POPBasicAnimation()
            alphaBasicAnimation.property = POPAnimatableProperty.propertyWithName(kPOPViewAlpha) as POPAnimatableProperty
            alphaBasicAnimation.fromValue = 1.0
            alphaBasicAnimation.toValue = 0.0
            alphaBasicAnimation.duration = kDuration //TODO:0.04
            from.view.pop_addAnimation(alphaBasicAnimation, forKey: "alphaBasicAnimation")
            
            var backgroundAlphaBasicAnimation = POPBasicAnimation()
            backgroundAlphaBasicAnimation.property = POPAnimatableProperty.propertyWithName(kPOPViewAlpha) as POPAnimatableProperty
            backgroundAlphaBasicAnimation.fromValue = kBackgroundAlpha
            backgroundAlphaBasicAnimation.toValue = 0.0
            backgroundAlphaBasicAnimation.duration = kDuration
            self.backgroundView.pop_addAnimation(backgroundAlphaBasicAnimation, forKey: "backgroundAlphaBasicAnimation")
        }
    }
    
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        if self.context!.transitionWasCancelled() {
            self.context!.completeTransition(false)
        } else {
            self.context!.completeTransition(true)
            
            if self.isReverse {
                let to = self.context!.viewControllerForKey(UITransitionContextToViewControllerKey)! as UIViewController
                
                //TODO
                //memo:http://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning
//                if (UIApplication.sharedApplication().keyWindow?.subviews as NSArray).containsObject(to.view) == false {
                    UIApplication.sharedApplication().keyWindow?.addSubview(to.view)
//                }
            }
        }
    }
}