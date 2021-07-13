# UIKitPresentationModifier

A modifier allowing you to present `UIKit` controllers natively from a `SwiftUI` context.

## Instalation

UIKitPresentationModifier is available via Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/mtzaquia/UIKitPresentationModifier.git", branch: "main"),
],
```

## Usage

The magic happens with the `.presentation(...)` modifier. Simply declare it as you'd normally do with `.sheet(...)` or `.fullScreenCover(...)`. The key difference here is that you need to provide a `UIViewController` which will configure the presentation, unlocking all the flexibility from `UIKit` presentations into your `SwiftUI` context.

```swift
myPresentingView
  .presentation(isPresented: $isPresented) {
    MyPresentedView()
  } controllerProvider: { content in
    let controller = UIHostingController(rootView: content)
    if #available(iOS 15, *) {
      if let sheet = controller.sheetPresentationController {
        sheet.preferredCornerRadius = 12
        sheet.prefersGrabberVisible = true
      }
    }
    
    return controller
  }
```

## License

Copyright (c) 2021 @mtzaquia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
