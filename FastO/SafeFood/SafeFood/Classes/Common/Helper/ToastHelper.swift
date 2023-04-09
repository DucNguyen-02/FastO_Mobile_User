import Toaster

class ToastHelper {

    static func showError(_ error: String?) {
        guard let error = error else {
            return
        }
        func show() {
            ToastHelper.showToast(error)
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async {
                show()
            }
        }
    }

    static func showToast(_ message: String?) {
        guard let message = message else {return}
        ToastCenter.default.cancelAll()
        Toast(text: message, delay: 0, duration: 1.5).show()
    }
}
