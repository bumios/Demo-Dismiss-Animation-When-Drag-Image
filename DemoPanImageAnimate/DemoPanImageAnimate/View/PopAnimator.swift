//
//  PopAnimator.swift
//  DemoPanImageAnimate
//
//  Created by Duy Tran N. on 2/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVFoundation

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: Double {
        if presenting {
            return 0.7
        }
        return 0.5
    }
    var presenting = true
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        /// `toView` is `new view to present`
        let toView = transitionContext.view(forKey: .to)
        /// `recipeView` is a place when `transition will be`
        var recipeView = presenting ? toView : transitionContext.view(forKey: .from)
        /// The actual frame displayed on screen of the image
        var actualImageRect: CGRect = CGRect.zero

        /// Find image view presented, and get `actual size` of image
        if !presenting {
            if let transitionView = transitionContext.containerView.subviews.first,
               let imageViewFromTransitionView = transitionView.subviews.first(where: { $0 is UIImageView }) as? UIImageView,
               let imageSize = imageViewFromTransitionView.image?.size {
                recipeView = imageViewFromTransitionView
                /// Find actual size of image
                actualImageRect = AVMakeRect(aspectRatio: imageSize, insideRect: containerView.frame)
            }
        }

        /// Setup `frame` & `scale`
        var initialFrame: CGRect = .zero
        var finalFrame: CGRect = .zero
        var xScaleFactor: CGFloat = .leastNonzeroMagnitude
        var yScaleFactor: CGFloat = .leastNonzeroMagnitude

        /// - Logic for animation
        if presenting {
            initialFrame = originFrame
            if let presentView = recipeView {
                finalFrame = presentView.frame
            }

            xScaleFactor = initialFrame.width / finalFrame.width
            yScaleFactor = initialFrame.height / finalFrame.height
        } else {
            initialFrame = actualImageRect
            finalFrame = originFrame

            xScaleFactor = finalFrame.width / initialFrame.width
            yScaleFactor = finalFrame.height / initialFrame.height
        }

        /// - Apply value
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        /// Add subviews
        if let unwrappedToView = toView {
            containerView.addSubview(unwrappedToView)
        }
        if let unwrappedRecipeView = recipeView {
            containerView.bringSubviewToFront(unwrappedRecipeView)
        }

        /// Set transform style begin scale from center
        if presenting {
            recipeView?.transform = scaleTransform
            recipeView?.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        }

        print("☘️ [Debug] initialFrame (x: \(initialFrame.origin.x), y: \(initialFrame.origin.y)), finalFrame (x: \(finalFrame.origin.x), y: \(finalFrame.origin.y))")
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.2,
            animations: { [weak self] in
                guard let this = self else { return }
                if this.presenting {
                    recipeView?.transform = .identity
                } else {
                    recipeView?.transform = scaleTransform
                }

                recipeView?.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}
