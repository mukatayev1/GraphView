//
//  StackedStickView.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/24.
//

import UIKit

class StackedStickView: UIView {
    
    //MARK: - Properties
    private var maxNumber: Double
    private var highValue: Double
    private var lowValue: Double
    private var secondNumber: Double
    private var thirdNumber: Double
    private let stickView: UIView = UIView()
    private let stickColor: UIColor
    
    //TapGesture
    private var index: Int = 0
    private var spaceFromTheTop: Double = 0
    private let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    weak var tapDelegate: StickViewTapDelegate?
    
    //State
    public var isSelected: Bool = false
    
    //Draw dash
    private var drawDashLine: Bool
    private var drawDateLabel: Bool
    private var period: ChartPeriodType
    
    private let topView: UIView = UIView()
    private let midView: UIView = UIView()
    private let bottomView: UIView = UIView()
    
    //MARK: - Lifecycle & Init
    init(maxNumber: Double, highValue: Double, lowValue: Double, index: Int, secondNumber: Double, thirdNumber: Double, stickColor: UIColor, drawDashLine: Bool, period: ChartPeriodType, drawDateLabel: Bool) {
        self.maxNumber = maxNumber
        self.highValue = highValue
        self.lowValue = lowValue
        self.index = index
        self.secondNumber = secondNumber
        self.thirdNumber = thirdNumber
        self.stickColor = stickColor
        self.drawDashLine = drawDashLine
        self.drawDateLabel = drawDateLabel
        self.period = period
        super.init(frame: .zero)
        validateHighAndLowValues()
        addSubviews()
        tapGestureAttributes()
        stickViewInitialConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        showStickAnimation()
        
        if drawDashLine {
            addLeftDashLine()
        }
        
        switch period {
        case .daily:
            switch index {
            case 0: addDateLabel(text: "오전 12시")
            case 12: addDateLabel(text: "오후 12시")
            case 6,18: addDateLabel(text: "6시")
            default: break
            }
            
        case .monthly:
            if drawDateLabel {
                addDateLabel(text: "\(index + 1)일")
            }
        default: break
        }
    }
    
    //MARK: - Point
    
    private func addDateLabel(text: String) {
        let dayLabel: UILabel = UILabel()
        dayLabel.font = .systemFont(ofSize: 14)
        dayLabel.textColor = #colorLiteral(red: 0.5440407395, green: 0.5651459694, blue: 0.6324952245, alpha: 1)
        dayLabel.textAlignment = .left
        dayLabel.text = text
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(5)
        }
    }
    
    private func addLeftDashLine() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        let color = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [10, 4]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: 330)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    //MARK: - Subviews
    private func addSubviews() {
        addSubview(stickView)
    }
    
    //MARK: - Attributes
    private func stickViewAttributes() {
        stickView.backgroundColor = stickColor
        stickView.layer.cornerRadius = (self.stickView.frame.width/2)
        stickView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func tapGestureAttributes() {
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(didTapOnStick(_:)))
    }
    
    private func topViewAttributes() {
        topView.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        topView.layer.cornerRadius = (self.stickView.frame.width/2)
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func midViewAttributes() {
        midView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    
    private func bottomViewAttributes() {
        bottomView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
    
    private func setupBackgroundColors(topHeight: Double, midHeight: Double, bottomHeight: Double) {
        topViewAttributes()
        midViewAttributes()
        bottomViewAttributes()
        topViewConstraint(height: topHeight)
        midViewConstraint(height: midHeight)
        bottomViewConstraint(height: bottomHeight)
    }
    
    //MARK: - Constraint
    private func stickViewConstraint() {
        let height = self.bounds.height
        let topOffset = (1 - (highValue * 0.6666)/secondNumber) * height
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            
            self.stickView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(topOffset < 0 ? 0 : topOffset).priority(.high)
                $0.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(1).priority(.high)
            }
            
            self.layoutIfNeeded()
        }, completion: nil)
        
        handleTooLowHeight()
        handleUserInteraction()
    }
    
    private func stickViewInitialConstraint() {
        stickView.snp.makeConstraints {
            
            $0.leading.trailing.equalToSuperview().inset(1).priority(.medium)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0).priority(.medium)
        }
    }
    
    //MARK: - Helpersff
    private func showStickAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.stickViewAttributes()
            self.stickViewConstraint()
            self.setupBackgroundColors(topHeight: 0, midHeight: 0, bottomHeight: 0)
        })
    }
    
    private func handleTooLowHeight() {
        if stickView.frame.height < stickView.frame.width && (highValue > 0 || lowValue > 0) {
            
            let topOffset = stickView.frame.origin.y
            let width = stickView.bounds.width
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                
                self.stickView.snp.remakeConstraints { make in
                    make.trailing.leading.equalToSuperview().inset(1)
                    make.height.equalTo(width)
                    if topOffset >= self.frame.height - self.frame.width {
                        make.bottom.equalToSuperview()
                    } else {
                        make.top.equalToSuperview().offset(topOffset)
                    }
                }
                
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func handleUserInteraction() {
        if highValue == 0 && lowValue == 0 {
            isUserInteractionEnabled = false
        } else {
            isUserInteractionEnabled = true
        }
    }
    
    private func validateHighAndLowValues() {
        if highValue > 0 && lowValue == 0 {
            lowValue = highValue
        } else if lowValue > 0 && highValue == 0 {
            highValue = lowValue
        }
    }
    
    private func topViewConstraint(height: Double) {
        if topView.superview == nil {
            addSubview(topView)
        }
        topView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalTo(stickView)
            make.height.equalTo(height)
        }
    }
    
    private func midViewConstraint(height: Double) {
        if midView.superview == nil {
            addSubview(midView)
        }
        midView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(stickView)
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(height)
        }
    }
    
    private func bottomViewConstraint(height: Double) {
        if bottomView.superview == nil {
            addSubview(bottomView)
        }
        bottomView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(stickView)
            make.top.equalTo(midView.snp.bottom)
            make.height.equalTo(height)
        }
    }
    
    
    //MARK: - Public methods
    public func setStickBackgroundColor(color: UIColor) {
        UIView.animate(withDuration: 0.17, delay: 0.0, options: .curveEaseInOut, animations: {
            
            self.stickView.backgroundColor = color
            
        }, completion: nil)
    }
    
    public func partialColors(topRatio: Double, midRatio: Double, lowRatio: Double) {
        let topHeight: Double = self.stickView.bounds.height * topRatio
        let midHeight: Double = self.stickView.bounds.height * midRatio
        let bottomHeight: Double = self.stickView.bounds.height - topHeight - midHeight
        
        setupBackgroundColors(topHeight: topHeight, midHeight: midHeight, bottomHeight: bottomHeight)
    }
    
    public func removeColoredBackground() {
        setupBackgroundColors(topHeight: 0, midHeight: 0, bottomHeight: 0)
    }
    
    //MARK: - Selectors
    @objc private func didTapOnStick(_ sender: UITapGestureRecognizer) {
        //Heptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        //Delegate method
        let xPoint = stickView.convert(stickView.bounds, to: UIScreen.main.fixedCoordinateSpace).origin.x
        let spaceFromTheTop = self.stickView.convert(CGPoint.zero, to: self.window!.coordinateSpace).y
        self.tapDelegate?.didTapStick(at: index, spaceFromTheTop: spaceFromTheTop, originXPoint: xPoint, width: stickView.bounds.width)
    }
    
}
