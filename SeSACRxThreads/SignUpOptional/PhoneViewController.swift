//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")

    let disposeBag = DisposeBag()
    
    let viewModel = PhoneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTextField.keyboardType = .numberPad
        
        view.backgroundColor = Color.white
        
        configureLayout()
        
        
        bind()
    }
    
    private func bind() {
        let input = PhoneViewModel.Input(tap: nextButton.rx.tap, text: phoneTextField.rx.text)
        let output = viewModel.tranform(input: input)
        
        output.validText
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 숫자 필터
        output.validationText
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 10글자 이상 입력가능
        output.validation
            .bind(with: self) { owner, value in
                let color : UIColor = value ? .systemBlue : .lightGray
                
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        // nextbutton
        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }


    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    


}

