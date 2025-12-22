//
//  Loading.swift
//  Area Master Tools
//
//  Created by Алкександр Степанов on 20.11.2025.
//

import SwiftUI

struct Loading: View {
    @State private var loadingProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack() {
                    Image("loadingBarback_1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.8)
                    
                    Image("loadingBarback_2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.78)
                    
                    Image("loadingBarFront")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.78)
                        .mask(
                            Rectangle()
                                .frame(width: screenWidth * 0.78 * loadingProgress)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        )
                    
                    Text("Loading...")
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.04))
                        .foregroundColor(.white)
                        .frame(width: screenWidth * 0.8)
                }
                .padding(.bottom, screenHeight * 0.1)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3.0)) {
                loadingProgress = 1.0
            }
        }
    }
}

#Preview {
    Loading()
}
