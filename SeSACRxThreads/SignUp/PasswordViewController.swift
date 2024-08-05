//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let descriptionLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    let viewModel = PasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
        
    }

    private func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func bind() {
        
        let input = PasswordViewModel.Input(text: passwordTextField.rx.text)
        let output = viewModel.transform(input: input)
        
        output.validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, value in
                let color : UIColor = value ? .systemPink : .systemGray
                owner.nextButton.backgroundColor  = color
            }
            .disposed(by: disposeBag)
        
        nextButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "확인",
            message: "가입 가능한 비밀번호입니다.",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "확인",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
