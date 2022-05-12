//
//  BaseConvertView.swift
//  Binary Box
//
//  Created by Ioan Moldovan on 27/03/2020.
//  Copyright © 2020 Ioan Moldovan. All rights reserved.
//

import SwiftUI

class BaseConvertViewModel: ObservableObject {
    var progChange: Bool = false
    
    @Published var decimalField: String = "" {
        didSet {
            if progChange { return }
            progChange = true
            if let dec = Int(decimalField) {
                binaryField = String(dec, radix: 2)
                hexField = String(dec, radix: 16).uppercased()
                octalField = String(dec, radix: 8)
            } else {
                binaryField = ""
                octalField = ""
                hexField = ""
            }
            progChange = false
        }
    }
    
    @Published var binaryField: String = ""{
        didSet {
            if progChange { return }
            progChange = true
            if let bin = Int(binaryField, radix: 2)
            {
                decimalField = String(bin, radix: 10)
                hexField = String(bin, radix: 16).uppercased()
                octalField = String(bin, radix: 8)
            } else {
                decimalField = ""
                octalField = ""
                hexField = ""
            }
            progChange = false
        }
    }
    
    @Published var octalField: String = ""{
        didSet {
            if progChange { return }
            progChange = true
            if let oct = Int(octalField, radix: 8)
            {
                decimalField = String(oct, radix: 10)
                hexField = String(oct, radix: 16).uppercased()
                binaryField = String(oct, radix: 2)
            } else {
                decimalField = ""
                binaryField = ""
                hexField = ""
            }
            progChange = false
        }
    }
    
    
    @Published var hexField: String = ""{
        didSet {
            if progChange { return }
            progChange = true
            hexField = hexField.uppercased()
            if let hex = Int(hexField, radix: 16)
            {
                decimalField = String(hex, radix: 10)
                binaryField = String(hex, radix: 2)
                octalField = String(hex, radix: 8)
            } else {
                decimalField = ""
                octalField = ""
                binaryField = ""
            }
            progChange = false
        }
    }
}

struct BaseConvertView: View {
    @ObservedObject var viewModel = BaseConvertViewModel()
    @Environment(\.application) var application
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading){
                    Text("Decimal").font(.title)
                    KeyboardTextField(text: $viewModel.decimalField, keyboardType: .numberPad, doneAction: {
                        self.application.endEditing()
                    }).fixedSize(horizontal: false, vertical: true)
                    
                    Divider().padding(30)
                    Text("Binary").font(.title)
                    
                    KeyboardTextField(text: $viewModel.binaryField, keyboardType: .numberPad, doneAction: {
                        self.application.endEditing()
                    }).fixedSize(horizontal: false, vertical: true)
                    
                    Divider().padding(30)
                    
                    VStack(alignment: .leading)
                    {
                        Text("Octal").font(.title)
                        
                        KeyboardTextField(text: $viewModel.octalField, keyboardType: .numberPad, doneAction: {
                            self.application.endEditing()
                        }).fixedSize(horizontal: false, vertical: true)
                        
                        Divider().padding(30)
                    }
                    Text("Hex").font(.title)
                    
                    KeyboardTextField(text: $viewModel.hexField, keyboardType: .namePhonePad, doneAction: {
                        self.application.endEditing()
                    }).fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                }.padding(20)
                    .navigationBarTitle("Base Convert")
            }
            
        }.onTapGesture {
            self.application.endEditing()
        }
    }
    
}


