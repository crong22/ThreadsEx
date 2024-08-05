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
        
    }
    
    struct Output {
        let validText : Observable<String>
    }
    
    func transform(input : Input) -> Output {
        let validText = Observable.just("8자 이상 입력해주세요")
        
        return Output(validText: validText)
    }
}
