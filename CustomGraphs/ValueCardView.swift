//
//  ValueCardView.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/17.
//

import UIKit

class ValueCardView: UIView {
    
    private let valueLabel: UILabel = UILabel()
    private let unitLabel: UILabel = UILabel()
    private let dateRangeLabel: UILabel = UILabel()
    private let textcolor: UIColor = #colorLiteral(red: 0.3403494656, green: 0.3641243875, blue: 0.4283151329, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let color: UIColor = #colorLiteral(red: 0.9688121676, green: 0.9688346982, blue: 0.9688225389, alpha: 1)
        backgroundColor = color
        
        addSubviews()
        
        valueLabelAttributes()
        unitLabelAttributes()
        dateRangeLabelAttributes()
        
        valueLabelConstraint()
        unitLabelConstraint()
        dateRangeLabelConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(valueLabel)
        addSubview(unitLabel)
        addSubview(dateRangeLabel)
    }
    
    private func valueLabelAttributes() {
        valueLabel.text = "0 - 0"
        valueLabel.font = .boldSystemFont(ofSize: 32)
        valueLabel.textColor = textcolor
    }
    
    private func dateRangeLabelAttributes() {
        dateRangeLabel.text = "2020년 12월"
        dateRangeLabel.textColor = textcolor
        dateRangeLabel.font = .systemFont(ofSize: 18)
    }
    
    private func unitLabelAttributes() {
        unitLabel.text = "mg/dL"
        unitLabel.font = .systemFont(ofSize: 16)
        unitLabel.textColor = #colorLiteral(red: 0.6817812324, green: 0.6817975044, blue: 0.6817887425, alpha: 1)
    }
    
    private func valueLabelConstraint() {
        valueLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    private func dateRangeLabelConstraint() {
        dateRangeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    private func unitLabelConstraint() {
        unitLabel.snp.makeConstraints {
            $0.bottom.equalTo(valueLabel.snp.bottom)
            $0.leading.equalTo(valueLabel.snp.trailing).offset(4)
        }
    }
    
    public func setValue(minValue: Int, maxValue: Int) {
        
        UIView.transition(with: valueLabel, duration: 0.15, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }
            
            if minValue > 0 && maxValue > 0 && maxValue != minValue {
                self.valueLabel.text = "\(minValue) - \(maxValue)"
            } else {
                self.valueLabel.text = "\(maxValue)"
            }
            
        }, completion: nil)
    }
    
}
