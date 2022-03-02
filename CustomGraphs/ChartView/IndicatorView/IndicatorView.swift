//
//  IndicatorView.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/17.
//

import UIKit

protocol IndicatorDelegate: AnyObject {
    func showIndicator(originX: Double, height: Double, width: Double, index: Int)
    func removeIndicator()
}

protocol IndicatorTriangleDelegate: AnyObject {
    func showTriangleView()
}

class IndicatorView: UIView {
    
    //MARK: - Properties
    private let indicatorLine: UIView = UIView()
    weak var triangleDelegate: IndicatorTriangleDelegate?
    
    override var bounds: CGRect {
        willSet {
            if bounds != newValue && newValue != .zero {
                triangleDelegate?.showTriangleView()
            }
        }
    }

    
    //MARK: - Lifecycle & Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        indicatorLineAttributes()
        indicatorLineConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToSuperview() {
        if superview == nil {
            bounds = .zero
        }
    }
    
    //MARK: - Subviews
    private func addSubviews() {
        addSubview(indicatorLine)
    }
    
    //MARK: - Attributes
    private func indicatorLineAttributes() {
        indicatorLine.backgroundColor = .white
    }
    
    //MARK: - Constraint
    private func indicatorLineConstraint() {
        indicatorLine.snp.makeConstraints {
            $0.width.equalTo(0.5)
            $0.top.centerX.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Public methods
    public func setIndicatorColor(_ color: UIColor) {
        self.indicatorLine.backgroundColor = color
    }
}
