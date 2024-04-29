//
//  StressLevelBackground.swift
//  NC1
//
//  Created by Theodore Mangowal on 29/04/24.
//

import SwiftUI

struct StressLevelBackground: View {
    @Binding var userStressLevel: StressLevel
    
    var body: some View {
        if userStressLevel == .low {
            Circle()
                .fill(
                    LinearGradient(colors: [.darkGreen, .lightGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 300, height: 150)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .transition(.opacity)
        } else if userStressLevel == .medium {
            Circle()
                .fill(
                    LinearGradient(colors: [.darkYellow, .lightYellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 300, height: 150)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .transition(.opacity)
        } else if userStressLevel == .high {
            Circle()
                .fill(
                    LinearGradient(colors: [.darkRed, .lightRed], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 300, height: 150)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .transition(.opacity)
        }
    }
}

//#Preview {
//    StressLevelBackground(userStressLevel: )
//}
