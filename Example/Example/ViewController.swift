//
//  ViewController.swift
//  Example
//
//  Created by ebt on 2016/12/9.
//  Copyright © 2016年 ebt. All rights reserved.
//

import UIKit
import RxUIAlertController
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func testAlert(_ sender: Any) {
        Alert(title: "Test", message: "This is a test message.")
            .addAction(title: "Yes")
            .addAction(title: "No", style: .destructive)
            .addTextField{
                $0.placeholder = "placeholder"
            }
            .rx.show()
            .subscribe(onNext: {
                print("button: \($0.buttonTitle)")
                print($0.controller.textFields?.first?.text ?? "")
            })
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func testActionSheet(_ sender: Any) {
        ActionSheet(title: "Test", message: "This is a test message.")
            .addAction(title: "Yes")
            .addAction(title: "No", style: .destructive)
            .addAction(title: "Cancel", style: .cancel)
            .rx.show()
            .subscribe(onNext: {
                print("button: \($0.buttonTitle)")
            })
            .addDisposableTo(disposeBag)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

