//
//  TriangleView.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/20.
//

import UIKit

class TriangleView: UIView {
    
    override var bounds: CGRect {
        didSet {
            drawIndicatorTriangle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawIndicatorTriangle() {
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width/2, y: 14))
        path.addLine(to: CGPoint(x: 0, y: 0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        let color: UIColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        shapeLayer.fillColor = color.cgColor
        shapeLayer.lineWidth = 28
        self.layer.addSublayer(shapeLayer)
    }
    
}
