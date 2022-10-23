//
//  BridgeView.swift
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

/// The `BridgeView` allows you to quickly inject a `UIView` into a `SwiftUI` hierarchy so that the responder chain is accessible.
///
/// The injected view will match the dimensions of its contents. That brings some extra convenience, such as allowing it to act as a source view for popover presentations.
///
/// - Important: You may need to wrap your view operations with `DispatchQueue.main.async { ... }` to receive up-to-date sizing information.
///
/// ```swift
/// BridgeView { proxy in
///     MyView() // The `proxy.uiView`'s size matches the rendered size of `MyView()`
/// }
/// ```
public struct BridgeView<Content>: View where Content: View {
    @State private var bridgeView = _BridgeView()
    private let content: (Proxy) -> Content
    
    public init(content: @escaping (Proxy) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(Proxy(uiViewController: bridgeView.uiViewController))
            .overlay(bridgeView.opacity(0))
    }
}

extension BridgeView {
    /// A proxy object containing an instance of a `UIView` which is injected into a `SwiftUI` hierarchy.
    public struct Proxy {
        public let uiViewController: UIViewController
        public var uiView: UIView { uiViewController.view }
    }
}

private extension BridgeView {
    private struct _BridgeView: UIViewControllerRepresentable {
        let uiViewController: UIViewController = UIViewController()
        func makeUIViewController(context: Context) -> some UIViewController { uiViewController }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
