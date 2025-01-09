//
//  ChaoInputView.swift
//  IMDemo
//
//  Created by mengxiangjian on 2025/1/8.
//

import UIKit
import SnapKit

enum ChaoInputViewState {
    // 初始状态，输入状态，扩展功能状态
case initial, inputing, extentFunction
}

protocol ChaoInputViewDelegate: NSObject {
    func inputView(_ inputView: ChaoInputView, didChangeToState state: ChaoInputViewState, keyboardHeight: CGFloat)
}

class ChaoInputView: UIView {
    
    var state = ChaoInputViewState.initial
    weak var delegate: ChaoInputViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        
        addSubview(textView)
        changeState(to: .initial, keyboardHeight: 0)
        
        addSubview(sendButton)
        sendButton.isHidden = true
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(textView)
            make.size.equalTo(CGSize(width: 44, height: 20))
        }
        
        addSubview(functionButton)
        functionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(textView)
            make.size.equalTo(CGSize(width: 27, height: 27))
        }
        
        addSubview(functionArea)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHeightChange(sender:)),
                                               name: ChaoInputView.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    @objc func keyboardHeightChange(sender: Any) {
        if let sender = sender as? Notification {
            if let userInfo = sender.userInfo, let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let beginFrame =  userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect{
                if frame.height > 100 && beginFrame.origin.y > frame.origin.y {
                    changeState(to: .inputing, keyboardHeight: frame.height)
                }
            }
        }
    }
    
    @objc func sendText() {
        
    }
    
    @objc func openFunction() {
        changeState(to: .extentFunction, keyboardHeight: 0)
    }
    
    lazy var textView: UITextView = {
        let view = UITextView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .yellow
        button.setTitle("发送", for: .normal)
        button.addTarget(self, action: #selector(sendText), for: .touchUpInside)
        return button
    }()
    
    lazy var functionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(openFunction), for: .touchUpInside)
        return button
    }()
    
    lazy var functionArea: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState(to state: ChaoInputViewState, keyboardHeight: CGFloat) {
        self.state = state
        layoutTextView()
        if state == .initial || state == .extentFunction {
            textView.resignFirstResponder()
        }
        delegate?.inputView(self, didChangeToState: state, keyboardHeight: keyboardHeight)
    }
    
    private func layoutTextView() {
        if state == .initial {
            textView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-textViewRightMargin)
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
                make.height.equalTo(textViewHeight)
            }
            functionArea.isHidden = true
        } else if state == .inputing {
            textView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-textViewRightMargin)
                make.bottom.equalToSuperview().offset(-10)
                make.height.equalTo(textViewHeight)
            }
            functionArea.isHidden = true
        } else if state == .extentFunction {
            textView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-textViewRightMargin)
                make.bottom.equalTo(functionArea.snp.top).offset(-10)
                make.height.equalTo(textViewHeight)
            }
            functionArea.isHidden = false
            functionArea.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
    
    private var textViewHeight: CGFloat {
        let height = textView.contentSize.height
        if height < 30 {
            return 30
        } else if height > 100 {
            return 100
        }
        return height
    }
    
    private var textViewRightMargin: CGFloat {
        if !textView.text.isEmpty {
            return 88
        }
        return 63
    }
    
}

extension ChaoInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.snp.updateConstraints { make in
            make.height.equalTo(textViewHeight)
            make.right.equalToSuperview().offset(-textViewRightMargin)
        }
        sendButton.isHidden = textView.text.isEmpty
        functionButton.isHidden = !textView.text.isEmpty
    }
}
