//
//  ContentView.swift
//  ButtonViewTest
//
//  Created by Warren Hansen on 1/3/24.
//

import SwiftUI

struct SelectionCell: View {
    
    let index: Int
    @Binding var leftSelected: Bool
    @Binding var selectedIndex: Int?

    @State private var textName : String = "L1"
    @State private var textAxial : String = "1.0"
    @State private var textSagittal : String = "10.0"
    @FocusState private var focusI: Bool
    @FocusState private var focusS: Bool
    @FocusState private var focusA: Bool
    
    var body: some View {
        
        // persist values
        let lumbarkey = ButtonStore(lumbarNum: index, leftSelected: leftSelected).indexKeys()
        let axKeysLeft = ButtonStore(lumbarNum: index, leftSelected: leftSelected).axKeys()
        let sgKeysLeft = ButtonStore(lumbarNum: index, leftSelected: leftSelected).sgKeys()
        @AppStorage(lumbarkey)  var lumbarLeft = "L\(index)"
        @AppStorage(axKeysLeft)  var axialLeft = 1.0
        @AppStorage(sgKeysLeft)  var sagitalLeft = 1.0
        
        HStack {
            Spacer()
            TextField("Lumbar", text: $textName)
                .focused($focusI)
                .onChange(of: focusI) { focused in
                    if focused {
                        textName = ""
                    } else {
                        lumbarLeft = textName
                    }
                }
                .onAppear() {
                    textName = lumbarLeft
                }
                .background(focusI ?  Color.white : Color.white.opacity(0.1))
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
                .background(focusA ?  Color.white : Color.white.opacity(0.1))
                .keyboardType(.numbersAndPunctuation)
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
                .background(focusS ?  Color.white : Color.white.opacity(0.1))
                .keyboardType(.numbersAndPunctuation)
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
    @State var indexArray = [1, 2, 3, 4, 5, 6]
    
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
                Text("SG").offset(x: 10, y: 0)
                Spacer()
            }
            .bold()
            .offset(x:-20, y: 0)
                
            // lumbar rows
            ForEach(indexArray, id: \.self) { item in
                SelectionCell(index: item, leftSelected: $leftSelected, selectedIndex: self.$selectedIndex)
            }
            Button {
                let newNum = indexArray.count + 1
                indexArray.append(newNum)
                UserDefaults.standard.set(indexArray, forKey: "IntArray")
            } label: {
                Label("Add", systemImage: "plus")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
        }.onAppear() {
            // reset array
            //UserDefaults.standard.set([1,2,3,4,5,6], forKey: "IntArray")
            let array = UserDefaults.standard.object(forKey:"IntArray") as? [Int] ?? [1,2,3,4,5,6]
            indexArray = array
            print("index arrary at launch is \(indexArray)")

        }
    }
}

#Preview {
    ButtonListView(leftSelected: .constant(false))
}
