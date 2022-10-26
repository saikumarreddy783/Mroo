//
//  KidScoreGuideTableViewCell.swift
//  Habitica
//
//  Created by Surya Pratap Singh on 22/09/22.
//  Copyright © 2022 HabitRPG Inc. All rights reserved.
//

import UIKit

class KidScoreGuideTableViewCell: UITableViewCell, Themeable {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var progressText: UILabel!
    
    var completedCount: Int = 0 {
        didSet {
            updateView()
        }
    }
    
    var totalCount: Int = 5 {
        didSet {
            updateView()
        }
    }
    
    var date: Date = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        btnNext.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        btnPrevious.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        // btnDate.addTarget(self, action: #selector(calenderTapped), for: .touchUpInside)
        
        ThemeService.shared.addThemeable(themable: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func applyTheme(theme: Theme) {
        progressBar.barBackgroundColor = ThemeService.shared.theme.offsetBackgroundColor
        progressBar.barColor = ThemeService.shared.theme.tintColor
        progressText.textColor = ThemeService.shared.theme.tintColor
        
        lblRate.textColor = UIColor.white
    }
    
    private func updateView() {
        progressBar.value = CGFloat(completedCount)
        progressBar.maxValue = CGFloat(totalCount)
        progressText.text = "Number of Prayers Prayed - \(completedCount)/\(totalCount)"
        setNeedsLayout()
    }
    
    
    func configure(date: Date) {
        self.date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let item = dateFormatter.string(from: date)
        btnDate.setTitle(item, for: .normal)
    }
    
    @objc func nextTapped() {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        configure(date: nextDate!)
    }
    
    @objc func previousTapped() {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
        configure(date: previousDate!)
    }
    
    @objc func calenderTapped() {
        
    }
}

class CustomDatePicker: UIView {
    
    var changeClosure: ((Date)->())?
    var dismissClosure: (()->())?

    let datePicker: UIDatePicker = {
        let v = UIDatePicker()
        v.tintColor = UIColor("#EA5455")
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() -> Void {
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.backgroundColor = UIColor("#222222").withAlphaComponent(0.3)
        
        let pickerHolderView: UIView = {
            let v = UIView()
            v.backgroundColor = .white
            v.layer.cornerRadius = 8
            return v
        }()
        
        [blurredEffectView, pickerHolderView, datePicker].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(blurredEffectView)
        pickerHolderView.addSubview(datePicker)
        addSubview(pickerHolderView)
        
        NSLayoutConstraint.activate([
            
            blurredEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurredEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),

            pickerHolderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            pickerHolderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            pickerHolderView.centerYAnchor.constraint(equalTo: centerYAnchor),

            datePicker.topAnchor.constraint(equalTo: pickerHolderView.topAnchor, constant: 20.0),
            datePicker.leadingAnchor.constraint(equalTo: pickerHolderView.leadingAnchor, constant: 20.0),
            datePicker.trailingAnchor.constraint(equalTo: pickerHolderView.trailingAnchor, constant: -20.0),
            datePicker.bottomAnchor.constraint(equalTo: pickerHolderView.bottomAnchor, constant: -20.0),

        ])
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // use default
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
        
        let t = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        blurredEffectView.addGestureRecognizer(t)
    }
    
    @objc func tapHandler(_ g: UITapGestureRecognizer) -> Void {
        dismissClosure?()
    }
    
    @objc func didChangeDate(_ sender: UIDatePicker) -> Void {
        changeClosure?(sender.date)
    }
    
}
