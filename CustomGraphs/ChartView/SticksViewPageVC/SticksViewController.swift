//
//  SticksViewController.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/12.
//

import UIKit

class SticksViewController: UIViewController {
    
    //MARK: - Properties
    private var maxNumber: Double
    private var graphBackgroundColor: UIColor
    private var graphTextColor: UIColor
    private let xAxisStack: UIStackView = UIStackView()
    private var periodType: ChartPeriodType
    private let sticksStack: UIStackView = UIStackView()
    private let dataset: [Int : GlucoseGraphModel]
    private var biggestValue: Int = 0
    private var secondNumber: Double
    private var thirdNumber: Double
    private let stickColor: UIColor
    private let unselectedColor: UIColor
    weak var indicatorDelegate: IndicatorDelegate?
    private let notificationCenter = NotificationCenter.default
    
    private var arrayOfMondays: [Int]
    
    //MARK: - Init & lifecycle
    init(maxNumber: Double, graphBackgroundColor: UIColor, graphTextColor: UIColor, periodType: ChartPeriodType, dataset: [Int : GlucoseGraphModel], secondNumber: Double, thirdNumber: Double, stickColor: UIColor,
         unselectedColor: UIColor, date: Date) {
        self.maxNumber = maxNumber
        self.graphBackgroundColor = graphBackgroundColor
        self.graphTextColor = graphTextColor
        self.periodType = periodType
        self.dataset = dataset
        self.secondNumber = secondNumber
        self.thirdNumber = thirdNumber
        self.stickColor = stickColor
        self.unselectedColor = unselectedColor
        self.arrayOfMondays = MonthWeekDateManager.getDatesForEvery(weekday: .monday, date: date)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        
        xAxisStackAttributes()
        sticksStackAttributes()
        
        sticksStackConstraint()
        
        setupXAxis()
        setupSticks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
        deselectAllSticks()
    }
    
    //MARK: - Subviews
    private func addSubviews() {
        view.addSubview(xAxisStack)
        view.addSubview(sticksStack)
    }
    
    //MARK: - Notification Center
    private func addObservers() {
        notificationCenter.addObserver(self, selector: #selector(deselectIndicators), name: NSNotification.Name("DeselectIndicators"), object: nil)
    }
    
    private func removeObservers() {
        notificationCenter.removeObserver(self, name: NSNotification.Name("DeselectIndicators"), object: nil)
    }
    
    //MARK: - Attributes
    private func xAxisStackAttributes() {
        xAxisStack.axis = .horizontal
        xAxisStack.distribution = .equalSpacing
    }
    
    private func sticksStackAttributes() {
        sticksStack.distribution = .fillEqually
        sticksStack.axis = .horizontal
        
        switch periodType {
        case .daily:
            sticksStack.spacing = 5
        case .weekly:
            sticksStack.spacing = 28
        case .monthly:
            sticksStack.spacing = 2
        }
    }
    
    //MARK: - Constraint
    private func xAxisStackConstraint() {
        var inset = 1
        if periodType == .weekly {
            inset = 16
        }
        xAxisStack.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(30)
            $0.trailing.leading.equalToSuperview().inset(inset)
        }
    }
    
    private func sticksStackConstraint() {
        sticksStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(xAxisStack)
            $0.bottom.equalTo(xAxisStack.snp.top)
        }
    }
    
    //MARK: - X axis logic
    private func setupXAxis() {
        switch periodType {
        case .weekly: setupWeekdays()
        default: break
        }
        xAxisStackConstraint()
    }
    
    private func setupWeekdays() {
        //Loop
        for i in 0..<self.dataset.count {
            //Label
            let weekLabel: UILabel = UILabel()
            weekLabel.font = .systemFont(ofSize: 14)
            weekLabel.textColor = graphTextColor
            weekLabel.textAlignment = .center
            weekLabel.snp.makeConstraints { $0.height.width.equalTo(20).priority(.medium) }
            //Switch
            switch i {
            case 0: weekLabel.text = "월"
            case 1: weekLabel.text = "화"
            case 2: weekLabel.text = "수"
            case 3: weekLabel.text = "목"
            case 4: weekLabel.text = "금"
            case 5: weekLabel.text = "토"
            case 6: weekLabel.text = "일"
            default: break
            }
            xAxisStack.addArrangedSubview(weekLabel)
        }
    }
    
    //MARK: - Sticks logic
    private func setupSticks() {
        for i in 0..<self.dataset.count {
            let stick = prepareStickView(forIndexKey: i)
            sticksStack.addArrangedSubview(stick)
            
            setBiggestValue(Int(dataset[i]!.maxValue))
        }
    }
    
    private func prepareStickView(forIndexKey key: Int) -> StackedStickView {
        var drawDashLine: Bool = false
        var drawDateLabel: Bool = false
        switch periodType {
        case .daily:
            drawDashLine = key % 6 == 0
            drawDateLabel = key % 6 == 0
        case .monthly:
            drawDashLine = self.arrayOfMondays.contains(key + 1)
            drawDateLabel = self.arrayOfMondays.contains(key + 1) && key + 1 != self.dataset.count
        default: break
        }
        let stick: StackedStickView = StackedStickView(maxNumber: maxNumber,
                                         highValue: dataset[key]!.maxValue,
                                         lowValue: dataset[key]!.minValue,
                                         index: key,
                                         secondNumber: self.secondNumber,
                                         thirdNumber: self.thirdNumber,
                                         stickColor: stickColor,
                                         drawDashLine: drawDashLine,
                                         period: self.periodType,
                                         drawDateLabel: drawDateLabel)
        stick.tapDelegate = self
        stick.snp.makeConstraints {
            $0.height.width.equalTo(20).priority(.medium)
        }
        return stick
    }
    
    //MARK: - Helpers
    private func setBiggestValue(_ value: Int) {
        if value > biggestValue {
            self.biggestValue = value
        }
    }
    
    private func deselectAllSticks() {
        sticksStack.arrangedSubviews.forEach { view in
            guard let stickView = view as? StackedStickView else { return }
            stickView.setStickBackgroundColor(color: stickColor)
            stickView.removeColoredBackground()
            stickView.isSelected = false
        }
        
        indicatorDelegate?.removeIndicator()
    }

    private func deselectAllSticks(except index: Int) {
        
        for (i, x) in sticksStack.arrangedSubviews.enumerated() {
            if i != index {
                guard let stickView = x as? StackedStickView else { return }
                stickView.setStickBackgroundColor(color: unselectedColor)
                stickView.removeColoredBackground()
                stickView.isSelected = false
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc private func deselectIndicators() {
        deselectAllSticks()
    }
}

//MARK: - StickViewTapDelegate
extension SticksViewController: StickViewTapDelegate {

    func didTapStick(at index: Int, spaceFromTheTop height: Double, originXPoint: Double, width: Double) {
        //IndicatorDelegate
        indicatorDelegate?.showIndicator(originX: originXPoint, height: height, width: width, index: index)
        
        for (i, x) in sticksStack.arrangedSubviews.enumerated() {
            guard let stickView = x as? StackedStickView else { return }

            if i == index && !stickView.isSelected {
                stickView.setStickBackgroundColor(color: stickColor)
                stickView.isSelected = true
                deselectAllSticks(except: i)
                stickView.partialColors(topRatio: 0.33, midRatio: 0.33, lowRatio: 0.33)
            } else if i == index && stickView.isSelected {
                deselectAllSticks()
            }
            
        }
        
    }
}
