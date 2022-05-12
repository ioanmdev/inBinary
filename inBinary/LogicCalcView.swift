//
//  LogicalCalcView.swift
//  Binary Box
//
//  Created by Ioan Moldovan on 27/03/2020.
//  Copyright © 2020 Ioan Moldovan. All rights reserved.
//

import SwiftUI

struct Results : Identifiable {
    var id = UUID()
    var operation: String
    var result: String
}

class LogicCalcViewModel: ObservableObject {
    
    var progChange : Bool = false
    
    @Published var base: String = "2"
        {
        didSet {
            if (progChange) { return }
            progChange = true
            doLogicOperations()
            progChange = false
        }
    }
    @Published var inputA: String = "0"
        {
        didSet {
            if (progChange) { return }
            progChange = true
            doLogicOperations()
            progChange = false
        }
    }
    
    @Published var inputB: String = "0"
        {
        didSet {
            if (progChange) { return }
            progChange = true
            doLogicOperations()
            progChange = false
        }
    }
    
    @Published var resultsModel : [Results]
    
    init() {
        resultsModel = [Results]()
        doLogicOperations()
    }
    
    func doLogicOperations()
    {
        resultsModel.removeAll()
        if let certainBase = Int(base) {
            if certainBase < 2 || certainBase > 16 { return }
            if let cert_inputA = Int(inputA, radix: certainBase) {
                if let cert_inputB = Int(inputB, radix: certainBase)
                {
                    let AND : Int = cert_inputA & cert_inputB
                    let OR : Int = cert_inputA | cert_inputB
                    let XOR : Int = cert_inputA ^ cert_inputB
                    let NOT_A : Int = bitFlip(cert_inputA)
                    let NOT_B : Int = bitFlip(cert_inputB)
                    let NAND : Int = bitFlip(AND)
                    let NOR : Int = bitFlip(OR)
                    resultsModel.append(Results(operation: "NOT A", result: String(NOT_A, radix:certainBase).uppercased()))
                    resultsModel.append(Results(operation: "NOT B", result: String(NOT_B, radix:certainBase).uppercased()))
                    resultsModel.append(Results(operation: "AND", result: String(AND, radix:certainBase).uppercased()))
                    resultsModel.append(Results(operation: "OR", result: String(OR, radix:certainBase).uppercased()))
                    resultsModel.append(Results(operation: "XOR", result: String(XOR, radix:certainBase).uppercased()))
                    resultsModel.append(Results(operation: "NAND", result: String(NAND, radix:certainBase).uppercased()))
                    resultsModel.append(Results(operation: "NOR", result: String(NOR, radix:certainBase).uppercased()))
                    
                    self.objectWillChange.send()
                    
                }
            }
        }
    }
    
    func bitFlip(_ x : Int) -> Int
    {
        var tmp: Int = x
        
        let numBits: Int = (x != 0) ? Int(log2(Double(x))) : 0
        
        for i in 0...numBits {
            tmp = tmp ^ (1 << i)
        }
        
        return tmp
    }
    
}

struct LogicCalcView: View {
    @ObservedObject var viewModel = LogicCalcViewModel()
    @Environment(\.application) var application
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Base").font(.title)
                    
                    KeyboardTextField(text: $viewModel.base, keyboardType: .numberPad, doneAction: {
                        self.application.endEditing()
                    }).fixedSize(horizontal: false, vertical: true)
                    
                    Divider().padding(15)
                    
                    Text("Input A").font(.title)
                    
                    KeyboardTextField(text: $viewModel.inputA, keyboardType: .namePhonePad, doneAction: {
                        self.application.endEditing()
                    }).fixedSize(horizontal: false, vertical: true)
                    
                    Divider().padding(15)
                    
                    Text("Input B").font(.title)
                    
                    KeyboardTextField(text: $viewModel.inputB, keyboardType: .namePhonePad, doneAction: {
                        self.application.endEditing()
                    }).fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading) {
                        Divider().padding(15)
                        HStack {
                            Text("Operation")
                                .frame(width:200, height: 10, alignment: .leading)
                            
                            VStack {
                                Text("Result")
                            }
                        }.font(.body)
                        List(viewModel.resultsModel, id: \.id) {
                            result in HStack {
                                Text("\(result.operation)")
                                    .frame(width:200, height: 10, alignment: .leading)
                                VStack {
                                    Text("\(result.result)")
                                }
                            }.font(.body)
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .topLeading)
                        Divider().padding(10)
                    }
                    
                    Spacer()
                    
                    
                }
                .padding(20)
                .navigationBarTitle("Logic Calculator")
            }
        }
        .onTapGesture {
            self.application.endEditing()
        }
    }
}
