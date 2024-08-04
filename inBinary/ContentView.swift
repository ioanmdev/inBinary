//
//  ContentView.swift
//  Binary Box
//
//  Created by Ioan Moldovan on 27/03/2020.
//  Copyright © 2020 Ioan Moldovan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BaseConvertView()
                .tabItem  {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Base Convert")
                }
            ASCIILookupView()
                .tabItem  {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("ASCII Lookup")
                }
            LogicCalcView()
                .tabItem  {
                    Image(systemName: "plus.slash.minus")
                    Text("Logic Calculator")
                }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
