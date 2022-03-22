//
//  ShowImageViewController.swift
//  DemoPanImageAnimate
//
//  Created by Duy Tran N. on 2/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController {

    @IBOutlet private weak var myImageView: UIImageView!
    @IBOutlet private weak var dismissButton: UIButton!

    /// Save the original point of an view
    var pointOrigin: CGPoint = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Add pan gesture to UIImageView
        myImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:))))
        /// Setup the original frame
        pointOrigin = myImageView.frame.origin
    }

    @IBAction private func dismissButtonTouchUpInside(_ button: UIButton) {
        dismiss(animated: true)
    }

    // MARK: - Objc functions
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        /// `Not allowed` the user to drag the view `upward`
        guard translation.y >= 0 else { return }

        /// Set x = 0 because we just handle scroll `vertically`
        myImageView.frame.origin = CGPoint(x: 0, y: pointOrigin.y + translation.y)

        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            /// The `percent` of vertical scrolled to be dismiss
            let scrolledPercent = myImageView.frame.origin.y / UIScreen.main.bounds.height * 100
            print("☘️ [Debug] translation.y: \(translation.y), frame.y: \(myImageView.frame.origin.y)")

            /// Apply dismiss when match `velocity` or `scrolled percent`
            if dragVelocity.y >= 1300 || scrolledPercent >= 25 {
                dismiss(animated: true, completion: nil)
            } else {
                /// Set back to original position
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let this = self else { return }
                    this.myImageView.frame.origin = this.pointOrigin
                }
            }
        }
    }
}
