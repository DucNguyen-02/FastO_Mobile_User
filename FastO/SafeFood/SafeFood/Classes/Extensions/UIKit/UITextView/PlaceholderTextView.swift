//
//  PlaceHolderTextView.swift
//  BithumbFashion
//
//  Created by Fu on 2/17/21.
//

import UIKit

@IBDesignable class PlaceholderTextView: UITextView {

    override var text: String! { // Ensures that the placeholder text is never returned as the field's text
        get {
            if showingPlaceholder {
                return "" // When showing the placeholder, there's no real text to return
            } else { return super.text }
        }
        set {
            if newValue != placeholderText.localized() {
                textColor = normalTextColor
                showingPlaceholder = false
            }
            super.text = newValue
        }
    }
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor = R.color.grayC2C3C4() ?? .gray
    @IBInspectable var normalTextColor: UIColor = R.color.black100() ?? .black
    private var showingPlaceholder: Bool = true // Keeps track of whether the field is currently showing a placeholder

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            if #available(iOS 13.0, *) {
                self.showPlaceholderText() // Load up the placeholder text when first appearing, but not if coming back to a view where text was already entered
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.showPlaceholderText()
                }
            }
        }
    }

    override func becomeFirstResponder() -> Bool {
        // If the current text is the placeholder, remove it
        if showingPlaceholder {
            text = nil
            textColor = normalTextColor // Put the text back to the default, unmodified color
            showingPlaceholder = false
        }
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        // If there's no text, put the placeholder back
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }

    private func showPlaceholderText() {
        showingPlaceholder = true
        textColor = placeholderTextColor
        text = placeholderText.localized()
    }

    func clearTextAndShowPlaceholder() {
        showPlaceholderText()
    }
}
