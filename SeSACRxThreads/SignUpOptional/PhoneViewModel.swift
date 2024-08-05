//
//  PhoneViewModel.swift
//  RxThreadsEx
//
//  Created by Woo on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    struct Input {
        let tap : ControlEvent<Void>
        let text : ControlProperty<String?>
    }
    
    struct Output {
        let tap : ControlEvent<Void>
        let validText : Observable<String>
        let validation : Observable<Bool>
        let validationText : Observable<String>
    }
    
    func tranform(input : Input) -> Output {
        
        let validText = Observable.just("010")
        
        let validation = input.text.orEmpty
            .map { $0.count > 9 }
        
        let validationText = input.text.orEmpty
            .map { $0.filter { "0123456789".contains($0) } }
        
        return Output(tap: input.tap, validText: validText, validation : validation, validationText : validationText)
    }
}
