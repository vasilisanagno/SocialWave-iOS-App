import SwiftUI

//component that shows the 6 small textfields that create the otp text field
struct OTPTextField: View {
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""
    @ObservedObject var sharedViewModel: SharedViewModel

    var body: some View {
        HStack {
            ForEach(0..<sharedViewModel.otp.count, id: \.self) { index in
                TextField("", text: $sharedViewModel.otp[index], onEditingChanged:
                    { editing in
                        if editing {
                            oldValue = sharedViewModel.otp[index]
                        }
                        if sharedViewModel.otp.allSatisfy({ !$0.isEmpty }) {
                            sharedViewModel.disabled = false
                        }
                        else {
                            sharedViewModel.disabled = true
                        }
                        sharedViewModel.errorCodeOTP = -1
                        sharedViewModel.errorOTP = false
                    })
                    .keyboardType(.numberPad)
                    .frame(width: 48, height: 48)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(sharedViewModel.errorOTP ? Color.red : Color.navyBlue, lineWidth: 1.5)
                    )
                    .accentColor(Color.navyBlue)
                    .multilineTextAlignment(.center)
                    .focused($fieldFocus, equals: index)
                    .tag(index)
                    .onChange(of: sharedViewModel.otp[index]) { _,newValue in
                        if sharedViewModel.otp[index].count > 1 {
                            let currentValue = Array(sharedViewModel.otp[index])
                            if !currentValue.isEmpty && !oldValue.isEmpty && currentValue[0] == Character(oldValue){
                                sharedViewModel.otp[index] = String(sharedViewModel.otp[index].suffix(1))
                            }
                            else{
                                sharedViewModel.otp[index] =
                                    String(sharedViewModel.otp[index].prefix(1))
                            }
                        }
                        if !newValue.isEmpty {
                            if index == sharedViewModel.otp.count - 1 {
                                fieldFocus = nil
                            }
                            else{
                                fieldFocus = (fieldFocus ?? 0) + 1
                            }
                        }
                        else{
                            fieldFocus = (fieldFocus ?? 0) - 1
                        }
                    }
            }
        }
    }
}
