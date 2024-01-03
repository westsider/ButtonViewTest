//
//  ContentView.swift
//  ButtonViewTest
//
//  Created by Warren Hansen on 1/3/24.
//

import SwiftUI

struct SelectionCell: View {

    let lumbarName: String
    @Binding var selectedLumbar: String?

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
                    textName = lumbarName
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
        .listRowBackground(lumbarName == selectedLumbar ? Color.blue.opacity(0.4) : Color.white)
        .onTapGesture {
            self.selectedLumbar = self.lumbarName
            print("selected lumbar \(String(describing: self.selectedLumbar))")
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
    @State var names = ["L1", "L2", "L3", "L4"]
    
    @State var selectedFruit: String? = nil
    
    var body: some View {
        List {
            //VStack {
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
                
                
                ForEach(names, id: \.self) { item in
                    SelectionCell(lumbarName: item, selectedLumbar: self.$selectedFruit)
                }
                Button {
                    let newNum = names.count + 1
                    names.append("L\(newNum)")
                } label: {
                    Label("Add", systemImage: "plus")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                }
            }
       // }
        
    }
}

#Preview {
    ButtonListView()
}
