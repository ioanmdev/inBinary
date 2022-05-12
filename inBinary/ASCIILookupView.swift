//
//  ASCIILookupView.swift
//  Binary Box
//
//  Created by Ioan Moldovan on 27/03/2020.
//  Copyright © 2020 Ioan Moldovan. All rights reserved.
//

import SwiftUI

struct ASCIITable : Identifiable{
    var id = UUID()
    var dec: String
    var hex: String
    var sym: String
}

class ASCIILookupViewModel: ObservableObject {
    
     @Published var searchText: String = "" {
         didSet {
            DispatchQueue.main.async {
                self.repopulateTable()
            }
         }
     }
    
    @Published var asciiData: [ASCIITable]
   
    
    init() {
        asciiData = [ASCIITable]()
        repopulateTable()
    }
    
    func repopulateTable()
    {
        asciiData.removeAll()
        
        if (searchText == "")
        {
            asciiData.append(ASCIITable(dec: "0", hex: "0", sym: "\\0" ))
            asciiData.append(ASCIITable(dec: "10", hex: "A", sym: "\\n" ))
            asciiData.append(ASCIITable(dec: "13", hex: "D", sym: "\\r" ))
        }
        
        if (searchText == "" || searchText == " ")
        {
            asciiData.append(ASCIITable(dec: "32", hex: "20", sym: "{SPACE}" ))
        }
        
        for i in 33...126 {
            let currentChar = String(Character(UnicodeScalar(i)!))
            let newElem = ASCIITable(dec: String(i), hex: String(i, radix:16).uppercased(), sym: currentChar)
            
            if (newElem.dec == searchText ||
                newElem.hex.lowercased() == searchText.lowercased() ||
                newElem.sym.lowercased() == searchText.lowercased() ||
                searchText == "") {
                
                asciiData.append(newElem)
            }
        }
    }
}


struct ASCIILookupView: View {
    @ObservedObject var viewModel = ASCIILookupViewModel()
    @Environment(\.application) var application
    
    var body: some View {
        
        NavigationView {
             VStack (alignment: .leading){
                Text("Search").font(.title)
                KeyboardTextField(text: $viewModel.searchText, keyboardType: .namePhonePad, doneAction: {
                        self.application.endEditing()
                }).fixedSize(horizontal: false, vertical: true)
                
                Divider().padding(30)
                HStack {
                        Text("HEX")
                            .frame(width:100, height: 10, alignment: .leading)
                        Text("DEC")
                            .frame(width:100, height: 10, alignment: .leading)
                    VStack {
                        Text("Symbol")
                    }
                }.font(.title)
                List(viewModel.asciiData) { ascii in
                    HStack {
                        Text("\(ascii.hex)")
                            .frame(width:100, height: 10, alignment: .leading)
                        Text("\(ascii.dec)")
                            .frame(width:100, height: 10, alignment: .leading)
                        VStack {
                            Text("\(ascii.sym)")
                        }
                    }.font(.title)
                }
                Divider().padding(10)
                Spacer()
                 
             }.padding(20)
             .navigationBarTitle("ASCII Lookup")
        }.onTapGesture {
            self.application.endEditing()
        }
    }
}
