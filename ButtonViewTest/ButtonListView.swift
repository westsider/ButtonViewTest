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
        
        //get values for lumbar selected and left / right selected
        let axSelected = "Selected" + ButtonStore(lumbarNum: index, leftSelected: leftSelected).axKeys()
        let sgSelected = "Selected" + ButtonStore(lumbarNum: index, leftSelected: leftSelected).sgKeys()
        @AppStorage(axSelected)  var axSelectedVal = 1.0
        @AppStorage(sgSelected)  var sgSelectedVal = 1.0
        
        HStack {
            Spacer(minLength: 30)
            Image(systemName: "lines.measurement.vertical")
            Spacer(minLength: 50)
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
        .listRowBackground(index == selectedIndex ? Color.blue.opacity(0.5) : Color.gray.opacity(0.1))
        //.border(index == selectedIndex ?  Color.black.opacity(0.5) : Color.gray.opacity(0.3), width: 2)
        
        .onTapGesture {
            self.selectedIndex = self.index
            let indexStr = String(describing: self.index)
            print("selected index \(indexStr) ax: \(axialLeft) sg: \(sagitalLeft)")
            // persist the values for use in crosshairs
            axSelectedVal = axialLeft
            sgSelectedVal = sagitalLeft
        }
    }
}

struct ButtonListView: View {

    @State var indexArray = [1, 2, 3, 4, 5, 6]
    @State private var showingAlert = false
    @State var selectedIndex: Int? = nil
    @State var leftSelected: Bool
    
    var body: some View {

        List {
            //  Title Row
            HStack {
                Spacer(minLength: 130)
                Text("")
                Spacer()
                Text("AX")
                Spacer()
                Text("SG")//.offset(x: 10, y: 0)
                Spacer()
            }
            .bold()
            //.offset(x:-20, y: 0)
            
            // lumbar rows
            if leftSelected {
                ForEach(indexArray, id: \.self) { item in
                    SelectionCell(index: item, leftSelected: $leftSelected, selectedIndex: self.$selectedIndex)
                }
            } else {
                ForEach(indexArray, id: \.self) { item in
                    SelectionCell(index: item, leftSelected: $leftSelected, selectedIndex: self.$selectedIndex)
                }
            }
            Button {
                let newNum = indexArray.count + 1
                indexArray.append(newNum)
                UserDefaults.standard.set(indexArray, forKey: "IntArray")
            } label: {
                Label("Add", systemImage: "plus")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            VStack {
                // left right buttons
                let screenWidth: CGFloat = UIScreen.main.bounds.width
                //let screenHeight: CGFloat = UIScreen.main.bounds.height
                let bttnWidth = screenWidth * 0.40
                let bttnHeight = 50.0
                Spacer()
                HStack {
                    SelectButton(height: bttnHeight, width: bttnWidth,
                                 isSelected: $leftSelected,
                                 text: "LEFT")
                    .onTapGesture {
                        leftSelected = true
                        print("left, leftSelected: \(leftSelected)")
                    }
                    SelectButton(height: bttnHeight, width: bttnWidth,
                                 isSelected: $leftSelected.not ,
                                 text: "RIGHT")
                    .onTapGesture {
                        leftSelected = false
                    }
                }
                
                Button("CLEAR ALL") {
                    showingAlert = true
                }
                .alert(isPresented: $showingAlert) {
                    return Alert(title: Text("Are you sure?"), primaryButton: .cancel(), secondaryButton: .default(Text("Clear Data"), action: {
                        //clearAllInputs()
                    }))
                }
                .font(.headline)
                .frame(width: screenWidth * 0.82, height: bttnHeight, alignment: .center)
                .background( Color.gray.opacity(0.3))
                .border(Color.gray.opacity(0.3), width: 2)
                .foregroundColor(.black)
                .cornerRadius(5)
            }.onAppear() {
                // reset array
                //UserDefaults.standard.set([1,2,3,4,5,6], forKey: "IntArray")
                let array = UserDefaults.standard.object(forKey:"IntArray") as? [Int] ?? [1,2,3,4,5,6]
                indexArray = array
                print("index arrary at launch is \(indexArray)")
            }
        }
    }
}
struct SelectButton: View {

    var height: Double
    var width: Double
    @Binding var isSelected: Bool
    @State var text: String

    var body: some View {
        ZStack {
            Text(text)
                .font(.headline)
                .frame(width: width, height: height, alignment: .center)
                .background(isSelected ?  Color.blue.opacity(0.5) : Color.gray.opacity(0.3))
                .border(isSelected ?  Color.black.opacity(0.5) : Color.gray.opacity(0.3), width: 2)
                .foregroundColor(.black)
                .cornerRadius(5)
            }
    }
}

extension Binding where Value == Bool {
    // nagative bool binding same as `!Value`
    var not: Binding<Value> {
        Binding<Value> (
            get: { !self.wrappedValue },
            set: { self.wrappedValue = $0}
        )
    }
}
#Preview {
    ButtonListView( leftSelected: true)
}
