import SwiftUI

struct EditRecordView: View {
    let work: Work
    let onBack: () -> Void
    let onSave: (Work) -> Void
    
    @State private var workName: String
    @State private var cost: String
    
    init(work: Work, onBack: @escaping () -> Void, onSave: @escaping (Work) -> Void) {
        self.work = work
        self.onBack = onBack
        self.onSave = onSave
        
        _workName = State(initialValue: work.name)
        _cost = State(initialValue: String(format: "%.2f", work.cost))
    }
    
    private var isFormValid: Bool {
        !workName.isEmpty && !cost.isEmpty && Double(cost) != nil
    }
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: onBack) {
                        Image("backButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.033)
                    }
                    .padding(.leading, screenWidth * 0.05)
                    
                    Text("Edit Record")
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
                
                VStack(spacing: screenHeight * 0.03) {
                    VStack(alignment: .leading, spacing: screenHeight * 0.01) {
                        Text("Work name:")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                            .foregroundColor(.white)
                        
                        TextField("", text: $workName)
                            .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                            .foregroundColor(.white)
                            .autocorrectionDisabled()
                            .padding(.bottom, screenHeight * 0.008)
                            .overlay(
                                Rectangle()
                                    .fill(.white)
                                    .frame(height: 1)
                                    .padding(.top, screenHeight * 0.04),
                                alignment: .bottom
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: screenHeight * 0.01) {
                        Text("Cost:")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                            .foregroundColor(.white)
                        
                        HStack(spacing: screenWidth * 0.01) {
                            Text("$")
                                .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                                .foregroundColor(.white)
                            
                            TextField("", text: $cost)
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
                .padding(.horizontal, screenWidth * 0.05)
                .padding(.top, screenHeight * 0.03)
                
                Spacer()
                
                Button(action: {
                    if isFormValid, let costValue = Double(cost) {
                        let updatedWork = Work(
                            id: work.id,
                            name: workName,
                            cost: costValue,
                            dateAdded: work.dateAdded
                        )
                        onSave(updatedWork)
                    }
                }) {
                    ZStack {
                        Image(isFormValid ? "redRect" : "grayRect")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.85)
                        
                        Text("Save")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                            .foregroundColor(.white)
                    }
                }
                .disabled(!isFormValid)
                .padding(.bottom, screenHeight * 0.15)
            }
            
            VStack {
                Spacer()
                BottomBar(selectedTab: .constant(.records))
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    EditRecordView(work: Work(name: "Plastering", cost: 1500.0), onBack: {}, onSave: { _ in })
}




