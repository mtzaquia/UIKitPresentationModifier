//
//  UIKitPresentationModifier.swift
//
//  Copyright (c) 2021 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

public extension View {
    /// Use this modifier to present a `UIKit` controller from `SwiftUI`.
    ///
    /// Provide a `UIViewController` instance from within the `controllerProvider` closure.
    /// Make sure to use the content provided to the closure as this is the `SwiftUI.View` you're attempting to present.
    /// You can configure the presentation of the controller as you'd normally do in a `UIKit` context. The `$isPresented` binding is automatically updated when the presentation is dismissed.
    ///
    /// ```
    /// myPresentingView
    ///   .presentation(isPresented: $isPresented) {
    ///       MyPresentedView()
    ///   } controllerProvider: { content in
    ///       let controller = UIHostingController(rootView: content)
    ///       if #available(iOS 15, *) {
    ///           if let sheet = controller.sheetPresentationController {
    ///               sheet.preferredCornerRadius = 12
    ///               sheet.prefersGrabberVisible = true
    ///           }
    ///       }
    ///
    ///       return controller
    ///   }
    /// ```
    ///
    /// - Important: The content view won't inherit custom values from the presentation's environment,
    /// so those need to be manually provided again as needed.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to the presentation.
    ///   - content: The content to be displayed inside the bottom sheet.
    ///   - controllerProvider: A closure returning the desired controller to be presented. Use this for customising your presentation and make sure
    ///   to include the provided `content` parameter in your result.
    func presentation<Presented, Controller>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Presented,
        controllerProvider: @escaping (Presented) -> Controller
    ) -> some View where Presented: View, Controller: UIHostingController<Presented> {
        modifier(
            UIKitPresentationModifier(
                isPresented: isPresented,
                content: content,
                controllerProvider: controllerProvider
            )
        )
    }
}

struct UIKitPresentationModifier<Presented, Controller>: ViewModifier where Presented: View, Controller: UIHostingController<Presented> {
    init(
        isPresented: Binding<Bool>,
        content: @escaping () -> Presented,
        controllerProvider: @escaping (Presented) -> Controller
    ) {
        _isPresented = isPresented
        self.content = content
        self.controllerProvider = controllerProvider
    }

    @Binding var isPresented: Bool
    let content: () -> Presented
    let controllerProvider: (Presented) -> Controller

    @State private var presentingViewController: UIViewController?
    @State private var observation: AnyObject?

    func body(content: Content) -> some View {
        content
            .background(BridgeView { proxy -> SwiftUI.Color in
                handlePresentation(from: proxy.uiView, isPresented: isPresented)
                return Color.clear
            })
    }
}

private extension UIKitPresentationModifier {
    func handlePresentation(from uiView: UIView, isPresented: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            isPresented ? present(from: uiView) : dismiss()
        }
    }

    func present(from view: UIView) {
        guard let presentingViewController = view.nearestViewController else {
            return
        }

        guard presentingViewController.presentedViewController == nil else {
            (presentingViewController.presentedViewController as? Controller)?.rootView = content()
            return
        }

        _ = UIViewController.swizzleViewDidDisappear

        let presentedController = controllerProvider(content())

        DispatchQueue.main.async {
            self.presentingViewController = presentingViewController
            observation = NotificationCenter.default.addObserver(
                forName: UIViewController.didDismissNotification,
                object: presentedController,
                queue: OperationQueue.main
            ) { _ in
                isPresented = false
            }
        }

        presentingViewController.present(presentedController, animated: true)
    }

    func dismiss() {
        DispatchQueue.main.async {
            observation = nil
        }

        presentingViewController?.presentedViewController?.dismiss(animated: true)
    }
}
