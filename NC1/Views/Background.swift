//
//  Background.swift
//  UwU
//
//  Created by Gracella Noveliora on 29/04/24.
//

import SwiftUI

struct Background: View {
    var body: some View {
        ZStack {
            VStack {
                Image(.loveBird).resizable().frame(width: 175, height: 70)
                
                Spacer()
                
            }.frame(maxWidth: .infinity, maxHeight: 500)
                .offset(CGSize(width: 0, height: -75))
            
            WaveAnimation()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [.purpleBg, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }


}

#Preview {
    Background()
}
