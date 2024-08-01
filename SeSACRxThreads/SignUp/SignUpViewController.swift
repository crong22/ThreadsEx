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
        nextButton.isEnabled = false
        nextButton.backgroundColor = falsecolor
        
        
        // 이메일 5자 이상 입력할 때 True
        // 단일 일때는 변수로하지말고 그냥 연달아 쓰기
        let email = emailTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { $0.count >= 5 }
        
        email
            .bind(with: self) { owner, value in
                // 5글자 이상이면 true 값 전달
                owner.validationLength.onNext(value)
                print("validationLength",value)
            }
            .disposed(by: disposeBag)
        
        
        // 이메일 일치할 때
        
        validationButton.rx.tap
            // 이메일 입력 값 text로 return
            .withLatestFrom(emailTextField.rx.text.orEmpty) { void, text in
                return text
            }
            // UI(탭) 행동이므로, bind로 이어준다.
            .bind(with: self) { owner, data in
                //for문 사용해서 일치하는 이메일 있는지 확인!
                for email in owner.list {
                    if data == email {
                        // 일치하면 validationSame = true
                        print("일치")
                        owner.validationSame.onNext(false)
                        // 계속 돌지못하게 return 해줌
                        return
                    }else {
                        print("불일치")
                        // 불일치하면 validationSame = false
                        owner.validationSame.onNext(true)
                        owner.validation()
                        return
                    }
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
    
    func validation() {
        // validationLength, validationSame
        Observable.zip(validationLength, validationSame) { one, two -> [Bool] in
            return [one,two]
        }
        .distinctUntilChanged()
        .bind(with: self, onNext: { owner, value in
            if value[0] == true , value[1] == true {
                print("0000000 \(value[0]), \(value[1])")
                owner.nextButton.isEnabled = true
                owner.nextButton.backgroundColor = owner.color
                owner.showAlert()
                return
            }else {
                print("11111111 \(value[0]), \(value[1])")
                owner.nextButton.isEnabled = false
                owner.nextButton.backgroundColor = owner.falsecolor
                return
            }
        })
        .disposed(by: disposeBag)
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
