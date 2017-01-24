//
//  AlertController.swift
//  Togazer
//
//  Created by roshanman on 16/9/14.
//  Copyright © 2016年 morenotepad. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@available(iOS 8.0, *)
public func Alert(title: String?, message: String?) -> AlertController  {
    return AlertController(title: title, message: message, preferredStyle: .alert)
}

@available(iOS 8.0, *)
public func ActionSheet(title: String?, message: String?) -> AlertController {
    return AlertController(title: title, message: message, preferredStyle: .actionSheet)
}

@available(iOS 8.0, *)
public class AlertController: NSObject {

    public struct Result {
        public let buttonIndex: Int
        public let buttonTitle: String
        public let controller: UIAlertController

        init(alert: UIAlertController, buttonTitle: String, buttonIndex: Int) {
            self.buttonTitle = buttonTitle
            self.buttonIndex = buttonIndex
            controller  = alert
        }
    }

    internal  let alertController: UIAlertController
    internal var observer: AnyObserver<Result>?
    private  var retainSelf: Any?
    private  let disposeBag = DisposeBag()

    init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle) {
        alertController = .init(title:title, message:message, preferredStyle:preferredStyle)

        super.init()

        alertController.rx.sentMessage(#selector(UIViewController.viewDidDisappear(_:)))
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.microseconds(300)) {
                    self?.retainSelf = nil
                }
            })
            .addDisposableTo(disposeBag)

        retainSelf = self
    }

    public func addAction(title: String, style: UIAlertActionStyle = .default,
                          configure: ((UIAlertController, UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style) { [unowned self] action in
            guard self != nil else { return }

            let result = Result(alert: self.alertController, buttonTitle: title,
                                buttonIndex: self.alertController.actions.index(of: action) ?? 0)

            self.observer?.onNext(result)
            self.observer?.onCompleted()
        }
        alertController.addAction(action)
        configure?(alertController, action)

        return self
    }

    @available(iOS 9.0, *)
    public func addPreferredAction(title: String, style: UIAlertActionStyle = .default,
                                   configure: ((UIAlertController, UIAlertAction) -> Void)? = nil)) -> Self {
        return addAction(title: title, style: style) { alertController, action in
          alertController.preferredAction = action
          configure?(alertController, action)
        }
    }

    public func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) -> Self {
        alertController.addTextField(configurationHandler: configurationHandler)

        return self
    }

    @discardableResult
    public func show(animated:Bool = true, completion: (() -> Void)? = nil) -> Self {
        if alertController.preferredStyle == .actionSheet &&
            UIDevice.current.userInterfaceIdiom == .pad
        {
            if let popOver = alertController.popoverPresentationController {
                if popOver.sourceView == nil {
                    if let topVC = self.topViewController {
                        popOver.sourceRect = topVC.view.bounds
                        popOver.sourceView = topVC.view
                    }
                }
            }
        }

        self.presentedController?.present(self.alertController,
                                          animated: animated,
                                          completion: completion)

        return self
    }

    private var presentedController:UIViewController? {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            //Find the presented view controller
            var presentedController = viewController

            while presentedController.presentedViewController != nil &&
                  presentedController.presentedViewController?.isBeingDismissed == false
            {
                presentedController = presentedController.presentedViewController!
            }

            return presentedController
        }

        return nil
    }

    private var topViewController:UIViewController? {
        var topController = self.presentedController

        while topController?.childViewControllers.last != nil {
            topController = topController?.childViewControllers.last!
        }

        return topController
    }


    /// For ActionSheet
    public func setBarButton(item: UIBarButtonItem) -> Self {
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            return self
        }

        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = item
        }

        return self
    }

    /// For ActionSheet
    public func setPresenting(source: UIView) -> Self {
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            return self
        }

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = source
            popoverController.sourceRect = source.bounds
        }

        return self
    }

    deinit {
        //print("deinit")
    }
}

public extension Reactive where Base: AlertController {
    public func show(animated: Bool = true, completion: (() -> Void)? = nil) -> Observable<AlertController.Result>  {
        self.base.show(animated: animated, completion: completion)

        return Observable.create { observer in
            self.base.observer = observer

            return Disposables.create()
        }
    }
}
