//
//  HomeViewController.swift
//  DemoPanImageAnimate
//
//  Created by Duy Tran N. on 2/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    let transition = PopAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NormalTableCell", bundle: nil), forCellReuseIdentifier: "NormalTableCell")
        tableView.register(UINib(nibName: "ImageTableCell", bundle: nil), forCellReuseIdentifier: "ImageTableCell")
        tableView.rowHeight = 100
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "NormalTableCell", for: indexPath)
        cell.backgroundColor = .white

        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell", for: indexPath)
            cell.backgroundColor = .darkGray
        }

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            let vc = ShowImageViewController()
            vc.modalPresentationStyle = .overCurrentContext
            /// Allow controller catch transition delegate of this VC
            vc.transitioningDelegate = self
            present(vc, animated: true)
        }
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedIndexPathCell = tableView.indexPathForSelectedRow,
              let selectedCell = tableView.cellForRow(at: selectedIndexPathCell) as? ImageTableCell,
              let selectedCellSuperview = selectedCell.superview else {
            return nil
        }

        /// Set the origin frame get from the cell superview
        var imageViewFrame = selectedCell.imageViewFrame()
        print("☘️ [Debug] imageViewFrame:", imageViewFrame)
        /// Add extra y-origin from above cell's (if has)
        imageViewFrame.origin.y += selectedCell.frame.origin.y
        print("☘️ [Debug] selectedCell.frame.origin.y:", selectedCell.frame.origin.y)
        /// Get the real frame `image view` versus `window`
        transition.originFrame = selectedCellSuperview.convert(imageViewFrame, to: nil)

        /// Update flag
        transition.presenting = true

        /// `return nil` if not want to apply animation
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        /// Update flag
        transition.presenting = false

        return transition
    }
}
