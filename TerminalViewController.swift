//
//  TerminalViewController.swift
//  libssh2-for-iOS
//
//  Created by peng hao on 2017/6/23.
//
//

import UIKit

class TerminalViewController: UIViewController, MTViewDelegate, SSHWrapperDelegate{
    func hasText() -> Bool {
        return true
    }

    @IBOutlet var textView: MTView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        appDelegate.sshWrapper.delegate = self
        let manager = KeyboardEventManager.shared()
        manager?.addObserver(Int(ESC_CODE), block: { [weak self] (isDown) in
            self?.sendInputByte(value: 27)
        })
    }

    func sendInputByte(value: Int8) {
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
        buffer.initialize(to: value)
        var error: NSError?
        try appDelegate.sshWrapper.send(buffer, error: &error)
        if error != nil {
            print(error!)
        }
    }
    
    func onHandleData(_ data: String!) {
        textView.onHandleInsertText(data)
    }
    
    func insertText(_ text: String!) {
        text.utf8CString.withUnsafeBufferPointer { [weak self] (ptr) in
            guard let ws = self else {
                return
            }
            ptr.forEach({ [weak ws] (v) in
                ws?.sendInputByte(value: v)
            })
        }
    }
    
    func deleteBackward() {
        sendInputByte(value: 10)
    }

}
