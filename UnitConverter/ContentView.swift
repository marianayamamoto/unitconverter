//
//  ContentView.swift
//  UnitConverter
//
//  Created by Mariana Yamamoto on 8/16/21.
//

import Combine
import SwiftUI

struct ContentView: View {
    @State private var inputUnit = 0
    @State private var outputUnit = 1
    @State private var inputValue = "1"

    private let units = ["C", "F", "K"]

    private func convertCelsiusToF(_ value: Double, reverse: Bool = false) -> Double {
        return reverse ? Double(5 / 9 * (value - 32)) : Double(1.8 * value + 32)
    }

    private func convertCelsiusToK(_ value: Double, reverse: Bool = false) -> Double {
        return reverse ? value - 273 : value + 273
    }

    var outputValue: Double {
        let selectedInputUnit = units[inputUnit]
        let selectedOutputUnit = units[outputUnit]
        let inputDouble = Double(inputValue) ?? 0

        switch (selectedInputUnit, selectedOutputUnit) {
        case ("C", "F"):
            return convertCelsiusToF(inputDouble)
        case ("C", "K"):
            return convertCelsiusToK(inputDouble)
        case ("F", "C"):
            return convertCelsiusToF(inputDouble, reverse: true)
        case ("K", "C"):
            return convertCelsiusToK(inputDouble, reverse: true)
        case ("F", "K"):
            return convertCelsiusToK(convertCelsiusToF(inputDouble, reverse: true))
        case ("K", "F"):
            return convertCelsiusToF(convertCelsiusToK(inputDouble, reverse: true))
        default:
            return inputDouble
        }
    }

    var body: some View {
        Form {
            Section {
                Text("Which unit is the original value?")
                Picker("Input unit", selection: $inputUnit) {
                    ForEach(0 ..< units.count) {
                        Text("\(self.units[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Text("Which unit you want the value in?")
                Picker("Output unit", selection: $outputUnit) {
                    ForEach(0 ..< units.count) {
                        Text("\(self.units[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Value", text: $inputValue)
                    .keyboardType(.numberPad)
                    .onReceive(Just(inputValue)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.inputValue = filtered
                        }
                    }
            }

            Section {
                Text("\(inputValue) \(units[inputUnit]) is \(outputValue, specifier: "%.2f") \(units[outputUnit])")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
