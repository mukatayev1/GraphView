//
//  StickView.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/12.
//

import UIKit

protocol StickViewTapDelegate: AnyObject {
    func didTapStick(at index: Int, spaceFromTheTop height: Double, originXPoint: Double, width: Double)
}

class StickView: UIView {
    
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
    }
    
    private func tapGestureAttributes() {
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(didTapOnStick(_:)))
    }
    
    
    
    //MARK: - Constraint
    private func stickViewConstraint() {
        let height = self.bounds.height
        let topOffset = (1 - (highValue * 0.6666)/secondNumber) * height
        let bottomInset = ((lowValue * 0.3333)/thirdNumber) * height
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            
            self.stickView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(topOffset < 0 ? 0 : topOffset).priority(.high)
                $0.bottom.equalToSuperview().inset(bottomInset).priority(.high)
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
    
    //MARK: - Public methods
    public func setStickBackgroundColor(color: UIColor) {
        UIView.animate(withDuration: 0.17, delay: 0.0, options: .curveEaseInOut, animations: {
            
            self.stickView.backgroundColor = color
            
        }, completion: nil)
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
