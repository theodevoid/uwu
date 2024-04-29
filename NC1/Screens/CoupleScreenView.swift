//
//  CoupleView.swift
//  UwU
//
//  Created by Gracella Noveliora on 29/04/24.
//

import SwiftUI

struct CoupleScreenView: View {
    var body: some View {
        ZStack {
            VStack {
                Image(.loveBird).resizable().frame(width: 175, height: 70)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(colors: [.darkYellow, .lightYellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 300, height: 150)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    
                    Image(.dog).resizable().frame(width: 106.33, height: 80)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 34))
                        .foregroundColor(Color.red)
                        .offset(x:-50, y:65)
                }.offset(CGSize(width: -75, height: 0))
                
                ZStack {
                    Circle()
                        .fill(
                            
                            LinearGradient(colors: [.darkGreen, .lightGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 300, height: 150)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    
                    Image(.cat).resizable().frame(width: 64.35, height: 80)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 34))
                        .foregroundColor(Color.red)
                        .offset(x:50, y:65)
                }.offset(CGSize(width: 75.0, height: 0))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "person.badge.plus").frame(width: 70, height: 30)
                        .foregroundColor(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.pastelPurple)
                                .shadow(radius: 5)
                        }
                }
                
            }.frame(maxWidth: .infinity, maxHeight: 500)
                .offset(CGSize(width: 0, height: -75))
            
            WaveAnimation()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [.purpleBg, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CoupleScreenView()
}
