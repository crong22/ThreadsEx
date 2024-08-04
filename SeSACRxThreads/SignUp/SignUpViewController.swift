//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// 2. 회원가입

final class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    var nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    var validationSame = BehaviorSubject(value: false)
    var validationLength = BehaviorSubject(value: false)
    // 중복리스트
    let list = ["Aaaaa", "Asdfg", "Qqqqq", "Qwert"]
    let color : UIColor = .systemBlue
    let falsecolor : UIColor = .systemRed
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        bindRx()
        
    }
    
    private func bindRx() {
        
        // 이메일 5자 이상 입력할 때 True
        // 단일 일때는 변수로하지말고 그냥 연달아 쓰기
        emailTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { $0.count >= 5 }
            .bind(with: self) { owner, value in
                // 5글자 이상이면 true 값 전달
                let color : UIColor = value ? .systemBlue : .systemRed
                owner.nextButton.backgroundColor  = color
                owner.nextButton.isEnabled = value ? value : !value
                owner.validationButton.isEnabled = value ? value : !value
                if value == true {
                    owner.sameRx()
                }
            }
            .disposed(by: disposeBag)
        
        
        // 다음 클릭 시 화면전환
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = PasswordViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func sameRx() {
        validationButton.rx.tap
            .withLatestFrom(emailTextField.rx.text.orEmpty) {void, text in
                return text }
            .bind(with: self) { owner, data in
                for email in owner.list {
                    if email == data {
                        return
                    }else {
                        owner.showAlert()
                        return
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func validation() {
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "가입가능",
            message: "가입 가능한 이메일입니다",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "확인",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
