//
//  BirthdayViewModel.swift
//  RxThreadsEx
//
//  Created by Woo on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let text : ControlProperty<Date> // birthDayPicker.rx.date
    }
    
    struct Output {
        let year : BehaviorRelay<Int>
        let month : BehaviorRelay<Int>
        let day : BehaviorRelay<Int>
    }
    
    func tranform(input : Input) -> Output {
        let year = BehaviorRelay(value: 2024)
        let month = BehaviorRelay(value: 8)
        let day = BehaviorRelay(value: 4)
        
        input.text
            .bind(with: self) { owner, data in
                
                let dayData = Calendar.current.dateComponents([.day, .month, .year], from: data)
                
                year.accept(dayData.year!)
                month.accept(dayData.month!)
                day.accept(dayData.day!)
            }
            .disposed(by: disposeBag)
        
        return Output(year: year, month: month, day: day)
    }
}
