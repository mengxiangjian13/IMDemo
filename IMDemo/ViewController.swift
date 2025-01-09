//
//  ViewController.swift
//  IMDemo
//
//  Created by mengxiangjian on 2025/1/7.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= 10 {
            return 44
        }
        return 88
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugPrint("scrollview contentoffset: \(scrollView.contentOffset), isDrag: \(scrollView.isDragging), istrack: \(scrollView.isTracking)")
        if scrollView.isTracking && chatInputView.state == .inputing {
            chatInputView.changeState(to: .initial, keyboardHeight: 0)
        }
    }
    
    
    var list = [String]()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    lazy var chatInputView: ChaoInputView = {
        let view = ChaoInputView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        debugPrint("tableview contentsize1: \(tableView.contentSize)")
        for i in 0..<10 {
            list.append("\(i)")
        }
        tableView.reloadData()
        debugPrint("tableview contentsize2: \(tableView.contentSize)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.tableView.scrollToRow(at: IndexPath(row: self.list.count - 1, section: 0),
//                                  at: .bottom, animated: true)
            for i in 10..<20 {
                self.list.insert("\(i)", at: 0)
            }
            self.tableView.reloadData()
            debugPrint("tableview contentsize3: \(self.tableView.contentSize)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        
        view.addSubview(chatInputView)
        chatInputView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
        
    }

    
}

extension ViewController: ChaoInputViewDelegate {
    
    func inputView(_ inputView: ChaoInputView, didChangeToState state: ChaoInputViewState, keyboardHeight: CGFloat) {
        if state == .initial {
            chatInputView.snp.remakeConstraints { make in
                make.bottom.left.right.equalToSuperview()
            }
        } else if state == .inputing {
            chatInputView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-keyboardHeight)
            }
        } else if state == .extentFunction {
            chatInputView.snp.remakeConstraints { make in
                make.bottom.left.right.equalToSuperview()
            }
        }
    }
    
}

