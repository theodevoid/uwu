//
//  StressLevelBackground.swift
//  NC1
//
//  Created by Theodore Mangowal on 29/04/24.
//

import SwiftUI

struct StressLevelBackground: View {
    @Binding var userStressLevel: StressLevel
    @Binding var animateGradient: Bool
    
    var body: some View {
        if userStressLevel == .low {
            Circle()
                .fill(
                    LinearGradient(colors: [.darkGreen, .lightGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 300, height: 150)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .rotationEffect(.degrees(animateGradient ? 360 : 0))
        } else if userStressLevel == .medium {
            Circle()
                .fill(
                    LinearGradient(colors: [.darkYellow, .lightYellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 300, height: 150)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .rotationEffect(.degrees(animateGradient ? 360 : 0))
        } else if userStressLevel == .high {
            Circle()
                .fill(
                    LinearGradient(colors: [.darkRed, .lightRed], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 300, height: 150)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .rotationEffect(.degrees(animateGradient ? 360 : 0))
        }
    }
}

//#Preview {
//    StressLevelBackground(userStressLevel: )
//}
