import SwiftUI

struct CalculateView: View {
    @State private var selectedWork: WorkType?
    @State private var showCalculationView = false
    @State private var showResultView = false
    @State private var calculationData: (height: Double, length: Double, pricePerM2: Double)?
    
    var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: screenWidth * 0.05),
            GridItem(.flexible(), spacing: screenWidth * 0.05)
        ]
    }
    
    var body: some View {
        if showResultView, let workType = selectedWork, let data = calculationData {
            ResultView(
                workType: workType,
                height: data.height,
                length: data.length,
                pricePerM2: data.pricePerM2
            ) {
                selectedWork = nil
                showCalculationView = false
                showResultView = false
                calculationData = nil
            }
        } else if showCalculationView, let workType = selectedWork {
            CalculationView(
                workType: workType,
                onBack: {
                    showCalculationView = false
                    selectedWork = nil
                },
                onCalculate: { height, length, pricePerM2 in
                    calculationData = (height, length, pricePerM2)
                    showResultView = true
                }
            )
        } else {
            calculateListView
        }
    }
    
    private var calculateListView: some View {
        VStack(spacing: 0) {
            Text("Calculate work")
                .font(.custom("Montserrat-Bold", size: screenWidth * 0.06))
                .foregroundColor(.white)
                .padding(.top, deviceHasSafeArea ? screenHeight * 0.015 : screenHeight * 0.02)
                .padding(.bottom, screenHeight * 0.015)
            
            Rectangle()
                .fill(.white)
                .frame(width: screenWidth, height: 1)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: screenHeight * 0.02) {
                    ForEach(workTypes, id: \.id) { workType in
                        WorkCard(workType: workType) {
                            selectedWork = workType
                            showCalculationView = true
                        }
                    }
                }
                .padding(.horizontal, screenWidth * 0.05)
                .padding(.top, screenHeight * 0.03)
                .padding(.bottom, screenHeight * 0.12)
            }
        }
    }
}

struct WorkCard: View {
    let workType: WorkType
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(workType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.42)
        }
    }
}

#Preview {
    CalculateView()
}

