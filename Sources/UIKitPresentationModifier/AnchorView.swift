//
//  AnchorView.swift
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

struct AnchorProxy {
	let uiView: UIView
}

struct AnchorView<Content>: View where Content: View {
	private struct _AnchorView: UIViewRepresentable {
		let uiView: UIView = UIView()
		func makeUIView(context: Context) -> some UIView { uiView }
		func updateUIView(_ uiView: UIViewType, context: Context) {}
	}

	@State private var anchorView = _AnchorView()
	private let content: (AnchorProxy) -> Content

	init(content: @escaping (AnchorProxy) -> Content) {
		self.content = content
	}

	var body: some View {
		content(AnchorProxy(uiView: anchorView.uiView))
			.overlay(anchorView.opacity(0))
	}
}
