//
//  SignUpViewModel.swift
//  RxThreadsEx
//
//  Created by Woo on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    
    struct Input {
        let tap : ControlEvent<Void>
        let text : ControlProperty<String?>
    }
    
    struct Output {
        let tap : ControlEvent<Void>
        let validation : Observable<Bool>
    }
    
    func tranform(input : Input) -> Output {
        
        let validation = input.text
            .orEmpty
            .distinctUntilChanged()
            .map { $0.count >= 5 }
        
        return Output(tap: input.tap, validation: validation)
    }
}
