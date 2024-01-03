//
//  ContentView.swift
//  ButtonViewTest
//
//  Created by Warren Hansen on 1/3/24.
//

import SwiftUI

struct SelectionCell: View {

    @Binding var leftSelected: Bool
    let index: Int
    @Binding var selectedIndex: Int?

    // set wide input
    @State private var textName : String = "L1"
    @State private var textAxial : String = "1.0"
    @State private var textSagittal : String = "10.0"
    
    
    // persist selected row
    @FocusState private var focusS: Bool
    @FocusState private var focusA: Bool
    
    var body: some View {
        
        // persist values
        let axKeysLeft = ButtonStore(lumbarNum: index, leftSelected: leftSelected).axKeys()
        let sgKeysLeft = ButtonStore(lumbarNum: index, leftSelected: leftSelected).sgKeys()
        @AppStorage(axKeysLeft)  var axialLeft = 1.0
        @AppStorage(sgKeysLeft)  var sagitalLeft = 1.0
        
        HStack {
            Spacer()
            TextField("LumbarName", text: $textName)
                .onAppear() {
                    textName = "L\(index)"
                }
            Spacer()
            TextField("Axial", text: $textAxial)
                .focused($focusA)
                .onChange(of: focusA) { focused in
                    if focused {
                        textAxial = ""
                    } else {
                        axialLeft = Utilities.getDoubleFrom(string: textAxial)
                        // remove incorrect characters
                        let filtered = textAxial.filter { "-.0123456789".contains($0) }
                        if filtered != textAxial {
                            self.textAxial = filtered
                            axialLeft = Utilities.getDoubleFrom(string: filtered)
                        }
                    }
                }
                .onAppear() {
                    textAxial = "\(axialLeft)"
                }
            Spacer()
            TextField("Sagittal", text: $textSagittal)
                .focused($focusS)
                .onChange(of: focusS) { focused in
                    if focused {
                        textSagittal = ""
                    } else {
                        sagitalLeft = Utilities.getDoubleFrom(string: textSagittal)
                        // remove incorrect characters
                        let filtered = textSagittal.filter { "-.0123456789".contains($0) }
                        if filtered != textSagittal {
                            self.textSagittal = filtered
                            //print("converted \(textSagittal)")
                            sagitalLeft = Utilities.getDoubleFrom(string: filtered)
                        }
                    }
                }
                .onAppear() {
                    textSagittal = "\(sagitalLeft)"
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
    
    @Binding var leftSelected: Bool
    
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
                SelectionCell(leftSelected: $leftSelected, index: item, selectedIndex: self.$selectedIndex)
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
    ButtonListView(leftSelected: .constant(false))
}
