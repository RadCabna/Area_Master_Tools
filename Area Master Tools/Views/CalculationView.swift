import SwiftUI

struct CalculationView: View {
    let workType: WorkType
    let onBack: () -> Void
    let onCalculate: (Double, Double, Double) -> Void
    
    @State private var height: String = ""
    @State private var length: String = ""
    @State private var pricePerM2: String = ""
    
    private var isFormValid: Bool {
        !height.isEmpty && !length.isEmpty && !pricePerM2.isEmpty &&
        Double(height) != nil && Double(length) != nil && Double(pricePerM2) != nil
    }
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Фиксированный header
                HStack {
                    Button(action: onBack) {
                        Image("backButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.033)
                    }
                    .padding(.leading, screenWidth * 0.05)
                    
                    Text(workType.title)
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.06))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    Color.clear
                        .frame(width: screenWidth * 0.033)
                        .padding(.trailing, screenWidth * 0.05)
                }
                .frame(height: screenHeight*0.06)
                .padding(.top, deviceHasSafeArea ? screenHeight * 0.015 : screenHeight * 0.02)
                .padding(.bottom, screenHeight * 0.015)
                
                Rectangle()
                    .fill(.white)
                    .frame(width: screenWidth, height: 1)
                
                // Скроллируемый контент
                ScrollView {
                    VStack(spacing: screenHeight * 0.03) {
                        InputField(title: "Height:", text: $height)
                        InputField(title: "Length:", text: $length)
                        InputField(title: "Price per m²:", text: $pricePerM2, prefix: "$")
                    }
                    .padding(.horizontal, screenWidth * 0.05)
                    .padding(.top, screenHeight * 0.03)
                    
                    Spacer()
                        .frame(height: screenHeight * 0.05)
                    
                    Button(action: {
                        if isFormValid {
                            calculateWork()
                        }
                    }) {
                        ZStack {
                            Image(isFormValid ? "redRect" : "grayRect")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.85)
                            
                            Text("Calculate")
                                .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(!isFormValid)
                    .padding(.bottom, screenHeight * 0.15)
                }
            }
            
            VStack {
                Spacer()
                BottomBar(selectedTab: .constant(.calculate))
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    private func calculateWork() {
        // Закрываем клавиатуру перед переходом на экран результата
        hideKeyboard()
        
        if let h = Double(height), let l = Double(length), let p = Double(pricePerM2) {
            onCalculate(h, l, p)
        }
    }
}

struct InputField: View {
    let title: String
    @Binding var text: String
    var prefix: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            Text(title)
                .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                .foregroundColor(.white)
            
            HStack(spacing: screenWidth * 0.01) {
                if let prefix = prefix {
                    Text(prefix)
                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                        .foregroundColor(.white)
                }
                
                TextField("", text: $text)
                    .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                    .foregroundColor(.white)
                    .keyboardType(.decimalPad)
                    .autocorrectionDisabled()
            }
            .padding(.bottom, screenHeight * 0.008)
            .overlay(
                Rectangle()
                    .fill(.white)
                    .frame(height: 1)
                    .padding(.top, screenHeight * 0.04),
                alignment: .bottom
            )
        }
    }
}

#Preview {
    CalculationView(workType: workTypes[0], onBack: {}, onCalculate: { _, _, _ in })
}

