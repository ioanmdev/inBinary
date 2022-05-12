//
//  KeyboardTextField.swift
//  Binary Box
//
//  Created by Ioan Moldovan on 02/04/2020.
//  Copyright © 2020 Ioan Moldovan. All rights reserved.
//

import SwiftUI
import UIKit

/// A text field view which represents an underlying `UITextField` instance, with a customized `UIKeyboardType`, and a custom action closure when the done button is touched.
struct KeyboardTextField: UIViewRepresentable {
    /* a two-way binding used to update the parent view and the underlying `UITextField` */
    @Binding var text: String
    /* customize the keyboard type on init */
    var keyboardType: UIKeyboardType
    
    
    /* provide a closure to handle the done button action */
    var doneAction: () -> Void
    
    /// A coordinator object used to forward data flow to and from the representable view and the `SwiftUI` interface.
    class Coordinator {
        private let textField: KeyboardTextField
        private let doneAction: () -> Void
        init(_ textField: KeyboardTextField, doneAction: @escaping () -> Void) {
            self.textField = textField
            self.doneAction = doneAction
        }
        
        @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
            /* forward the touch event to the external caller */
            doneAction()
        }
        
        @objc func textFieldDidChange(_ sender: UITextField) {
            textField.text = sender.text ?? ""
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, doneAction: doneAction)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyboardType
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = .no
   
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped(_:)))
        toolbar.items = [flexSpace, doneButton]
        
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        /* update the text field with state changes, or changes from the context, if needed */
        uiView.text = text
    }
}
