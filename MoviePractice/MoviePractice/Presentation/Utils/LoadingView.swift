import UIKit

class LoadingView {
    private static var spinner: UIActivityIndicatorView?
    private static weak var currentWindow: UIWindow?

    static func show(in window: UIWindow? = currentKeyWindow()) {
        DispatchQueue.main.async {
            guard let window = window else { return }
            
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)

            if spinner == nil {
                let frame = UIScreen.main.bounds
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                spinner.style = .large
                window.addSubview(spinner)

                spinner.startAnimating()
                self.spinner = spinner
                self.currentWindow = window
            }
        }
    }

    static func hide() {
        DispatchQueue.main.async {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            spinner = nil
            currentWindow = nil
        }
    }

    @objc private static func update() {
        if spinner != nil {
            hide()
            show()
        }
    }

    private static func currentKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
