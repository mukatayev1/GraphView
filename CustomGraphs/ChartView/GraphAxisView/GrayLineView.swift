//
//  GrayLineView.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/07.
//

import UIKit

class GrayLineView: UIView {
    
    //MARK: - Properties
    private let lineView: UIView = UIView()
    private let numberLabel: UILabel = UILabel()
    private let position: GrayLineViewPosition!
    private var gridColor: UIColor
    private var textColor: UIColor
    
    //MARK: - Init
    init(frame: CGRect, position: GrayLineViewPosition, gridColor: UIColor, textColor: UIColor) {
        self.position = position
        self.gridColor = gridColor
        self.textColor = textColor
        super.init(frame: frame)
        
        addSubviews()
        lineViewAttributes()
        numberLabelAttributes()
        
        lineViewConstraint()
        numberLabelConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - subviews
    private func addSubviews() {
        addSubview(lineView)
        addSubview(numberLabel)
    }
    
    //MARK: - Attributes
    private func lineViewAttributes() {
        lineView.backgroundColor = gridColor
    }
    
    private func numberLabelAttributes() {
        numberLabel.textAlignment = .center
        numberLabel.font = .systemFont(ofSize: 14, weight: .light)
        numberLabel.textColor = textColor
    }
    
    //MARK: - Constraint
    private func lineViewConstraint() {
        lineView.snp.makeConstraints {
            switch self.position {
            case .center: $0.centerY.equalToSuperview()
            case .bottom: $0.bottom.equalTo(self.snp.bottom)
            case .top: $0.top.equalTo(self.snp.top)
            default: $0.centerY.equalTo(self.snp.centerY)
            }
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(37)
            $0.height.equalTo(1)
        }
    }
    
    private func numberLabelConstraint() {
        numberLabel.snp.makeConstraints {
            $0.centerY.equalTo(lineView.snp.centerY)
            $0.leading.equalTo(lineView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
        }
    }
    
    //MARK: - Public methods
    public func setNumberValue(_ number: Int) {
        self.numberLabel.text = String(number)
    }
}

//MARK: - GrayLineViewPosition
extension GrayLineView {
    enum GrayLineViewPosition {
        case top
        case center
        case bottom
    }
}
