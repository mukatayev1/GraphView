//
//  GraphAxisView.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/12.
//

import UIKit
import SnapKit

class GraphAxisView: UIView {
    
    //MARK: - Properties
    private let verticalChartView: UIStackView = UIStackView()
    //StackViews
    private lazy var grayLine1: GrayLineView = GrayLineView(frame: .zero, position: .top, gridColor: gridColor, textColor: textColor)
    private lazy var grayLine2: GrayLineView = GrayLineView(frame: .zero, position: .center, gridColor: gridColor, textColor: textColor)
    private lazy var grayLine3: GrayLineView = GrayLineView(frame: .zero, position: .center, gridColor: gridColor, textColor: textColor)
    private lazy var grayLine4: GrayLineView = GrayLineView(frame: .zero, position: .bottom, gridColor: gridColor, textColor: textColor)
    
    private var firstValue: Int = 0
    private var secondValue: Int = 0
    private var thirdValue: Int = 0
    
    private var textColor: UIColor = .gray
    private var gridColor: UIColor = .gray
    
    private var goalMax: Int = 0
    private var goalMin: Int = 0
    private let rangeView: UIView = UIView()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        rangeViewAttributes()
        verticalStackViewAttributes()
        rangeViewConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        verticalStackViewConstraint()
        rangeViewConstraint()
    }
    
    //MARK: - subviews
    private func addSubviews() {
        addSubview(verticalChartView)
        addSubview(rangeView)
    }
    
    //MARK: - Attributes
    private func verticalStackViewAttributes() {
        verticalChartView.axis = .vertical
        verticalChartView.distribution = .equalSpacing
    }
    
    private func rangeViewAttributes() {
        rangeView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1)
        rangeView.alpha = 0.2
    }
    
    //MARK: - Constraint
    private func verticalStackViewConstraint() {
        verticalChartView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func addLeftBorderLine() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = gridColor.cgColor
        shapeLayer.lineWidth = 1
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: self.frame.height)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    private func addLeftDashLine() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = gridColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [10, 4]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: self.frame.height + 30)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    private func rangeViewConstraint() {
        rangeView.snp.makeConstraints {
            $0.top.bottom.equalTo(snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(37)
        }
    }
    
    //MARK: - Logic
    private func setupVerticalViewViews() {
        //clean up stackview
        cleanUpStackView()
        grayLine1.setNumberValue(Int(firstValue))
        grayLine2.setNumberValue(Int(secondValue))
        grayLine3.setNumberValue(Int(thirdValue))
        grayLine4.setNumberValue(0)
        
        verticalChartView.addArrangedSubview(grayLine1)
        verticalChartView.addArrangedSubview(grayLine2)
        verticalChartView.addArrangedSubview(grayLine3)
        verticalChartView.addArrangedSubview(grayLine4)
    }
    
    private func cleanUpStackView() {
        verticalChartView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func presentRange() {
        let height = self.bounds.height
        let topOffset: Double = (1 - (Double(goalMax)/Double(firstValue))) * Double(height)
        let bottomInset: Double = (Double(goalMin)/Double(firstValue)) * Double(height)
        self.rangeView.snp.remakeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(37)
            $0.top.equalToSuperview().offset(topOffset)
            $0.bottom.equalToSuperview().inset(bottomInset)
        }
    }
    
    //MARK: - Public funcs
    public func setHeroValue(goalMax: Int, goalMin: Int) {
        self.goalMax = goalMax
        self.goalMin = goalMin
    }
    
    public func setupGridView(leftDashLine: Bool) {
        //call this method in viewDidLayoutSubviews() of a ViewController
        //the superview needs to have a frame in order to setup verticalView and LeftBorderLine
        setupVerticalViewViews()
        leftDashLine ? addLeftDashLine() : addLeftBorderLine()
        presentRange()
    }
    
    public func setYAxisLabels(firstValue: Int, secondValue: Int, thirdValue: Int) {
        if firstValue > secondValue && secondValue > thirdValue {
            self.firstValue = firstValue
            self.secondValue = secondValue
            self.thirdValue = thirdValue
        } else if firstValue > secondValue && firstValue > thirdValue {
            self.firstValue = firstValue
            self.secondValue = Int(Double(firstValue) * 0.66)
            self.thirdValue = Int(Double(firstValue) * 0.33)
        } else {
            assert(false, "\nY-axis values were set in wrong order. \nValues should go in order: firstValue > secondValue > thirdValue. First value has to be the biggest and third value has to be the smallest")
        }
    }
    
    public func setColors(textColor: UIColor, gridColor: UIColor) {
        self.textColor = textColor
        self.gridColor = gridColor
    }
}
