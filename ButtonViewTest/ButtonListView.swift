//
//  ContentView.swift
//  ButtonViewTest
//
//  Created by Warren Hansen on 1/3/24.
//

import SwiftUI

struct SelectionCell: View {

    let index: Int
    @Binding var selectedIndex: Int?

    // set wide input
    @State private var textName : String = "L1"
    @State private var textAxial : String = "1.0"
    @State private var textSagittal : String = "10.0"
    
    // persist values
    
    // persist selected row
    
    var body: some View {
        HStack {
            Spacer()
            TextField("LumbarName", text: $textName)
                .onAppear() {
                    textName = "L\(index)"
                }
            Spacer()
            TextField("textAxial", text: $textAxial)
                .onAppear() {
                    textAxial = textAxial
                }
            Spacer()
            TextField("textSagittal", text: $textSagittal)
                .onAppear() {
                    textAxial = textAxial
                }
        }
        .listRowBackground(index == selectedIndex ? Color.blue.opacity(0.4) : Color.white)
        .onTapGesture {
            self.selectedIndex = self.index
            let indexStr = String(describing: self.index)
            print("selected index \(indexStr)")
        }
    }
}

struct ButtonListView: View {

    /*
     let screenWidth: CGFloat
     @State private var toggleManager = ToggleManager()
     @State private var leftSelected = true
     @State private var showingAlert = false
     @StateObject var toggleSet = ToggleSettings()
     */
    @State var names = [1, 2, 3, 4]
    
    @State var selectedIndex: Int? = nil
    
    var body: some View {
        List {
            //  Title Row
                HStack {
                    Spacer()
                    Text("")
                    Spacer()
                    Text("AX")
                    Spacer()
                    Text("SG")
                    Spacer()
                }
                .bold()
                
                // lumbar rows
                ForEach(names, id: \.self) { item in
                    SelectionCell(index: item, selectedIndex: self.$selectedIndex)
                }
                Button {
                    let newNum = names.count + 1
                    names.append(newNum)
                } label: {
                    Label("Add", systemImage: "plus")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
            }
    }
}

#Preview {
    ButtonListView()
}
