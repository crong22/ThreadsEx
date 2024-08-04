//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    var yearData = BehaviorRelay(value: 2024)
    var yearBool = BehaviorRelay(value: false)
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let monthData = BehaviorRelay(value: 8)
    var monthBool = BehaviorRelay(value: false)
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let dayData = BehaviorRelay(value: 4)
    var dayBool = BehaviorRelay(value: false)
    
    let nextButton = PointButton(title: "가입하기")
    
    let disposeBag = DisposeBag()
    
    let birth = Birth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
        
    }
    
    
    
    private func bind() {
        
        birthDayPicker.rx.date
            .bind(with: self) { owner, data in
                let dayData = Calendar.current.dateComponents([.day, .month, .year], from: data)
                
                owner.yearData.accept(dayData.year!)
                owner.monthData.accept(dayData.month!)
                owner.dayData.accept(dayData.day!)
                
            }
            .disposed(by: disposeBag)
        
        yearData
            .bind(with: self, onNext: { owner, year in

                if year <= ( owner.birth.yearCurrent - 17 ) {
                    owner.yearLabel.text = "\(year)년"
                    owner.yearBool.accept(true)
//                    print("yearbool,  \(owner.yearBool)")
                    
                }else {

                    owner.yearLabel.text = "\(year)년"
                    owner.yearBool.accept(false)

                }
            })
            .disposed(by: disposeBag)

        
        monthData
            .bind(with: self, onNext: { owner, month in

                if month <=  owner.birth.monthCurrent  {
                    owner.monthLabel.text = "\(month)월"
                    owner.monthBool.accept(true)
//                    print("monthbool , \(owner.monthBool)")

                }else {

                    owner.monthLabel.text = "\(month)월"
                    owner.monthBool.accept(false)

                }
            })
            .disposed(by: disposeBag)
        
        dayData
            .bind(with: self, onNext: { owner, day in

                if day <=  owner.birth.dayCurrent  {
                    owner.dayLabel.text = "\(day)월"
                    owner.dayBool.accept(true)
//                    print("daybool,  \(owner.dayBool)")
                }else {

                    owner.dayLabel.text = "\(day)월"
                    owner.dayBool.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(yearBool, monthBool, dayBool) { one,two,three -> [Bool] in
            return [one,two,three]
        }
        .bind(with: self) { owner, datebool in
            if datebool[0] == true , datebool[1] == true, datebool[2] == true {
                owner.infoLabel.textColor = .systemBlue
                owner.nextButton.isEnabled = true
                owner.nextButton.backgroundColor = .systemBlue
                return
            }else {
                owner.infoLabel.textColor = .systemRed
                owner.nextButton.isEnabled = false
                owner.nextButton.backgroundColor = .systemRed
                return
            }
        }
        .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
        
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
