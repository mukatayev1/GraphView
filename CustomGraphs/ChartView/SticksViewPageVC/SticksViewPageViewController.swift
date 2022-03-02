//
//  SticksViewPageViewController.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/12.
//

import UIKit

class SticksViewPageViewController: UIPageViewController {

    private var pages: [UIViewController] = []
    private var maxNumber: Double = 0
    private var isSomething: Bool = false
    
    init(pages: [UIViewController]) {
        self.pages = pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        dataSource = self
        delegate = self
        setViewControllers()
    }
    
    private func setViewControllers() {
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }
}

//MARK: - UIPageViewControllerDataSource
extension SticksViewPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if isSomething { return nil }
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }
//
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if isSomething { return nil }
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        let orderedPagesCount = pages.count
        guard orderedPagesCount != nextIndex else { return pages.first }
        guard orderedPagesCount > nextIndex else { return nil }

        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        isSomething = true
    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        if isSomething {
//            view.isUserInteractionEnabled = false
//        }
//    }
}
