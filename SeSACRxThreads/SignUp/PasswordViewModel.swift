//
//  PasswordViewModel.swift
//  RxThreadsEx
//
//  Created by Woo on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    
    struct Input {
        let text : ControlProperty<String?> //passwordTextField.rx.text
        let tap : ControlEvent<Void>
    }
    
    struct Output {
        let tap : ControlEvent<Void>
        let validText : Observable<String>
        let validation : Observable<Bool>
    }
    
    func transform(input : Input) -> Output {
        let validation = input.text.orEmpty
            .map { $0.count > 7 }
        
        let validText = Observable.just("8자 이상 입력해주세요")
        
        
        return Output(tap: input.tap, validText: validText, validation: validation)
    }
}
