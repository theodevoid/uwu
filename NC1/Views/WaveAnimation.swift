//
//  WaveAnimation.swift
//  UwU
//
//  Created by Gracella Noveliora on 27/04/24.
//

import SwiftUI

struct WaveAnimation: View {
    
    @State private var percentP = 7.5
    @State private var waveOffsetP = Angle(degrees: 180)
    
    @State private var percentB = 15.0
    @State private var waveOffsetB = Angle(degrees: 0)
    
    var body: some View {
        ZStack {
            WaveB(offSet: Angle(degrees: waveOffsetB.degrees), percentB: percentB)
                .fill(Color.pastelBlue)
                .ignoresSafeArea(.all)
            WaveP(offSet: Angle(degrees: waveOffsetP.degrees), percentP: percentP)
                .fill(Color.lightPink)
                .ignoresSafeArea(.all)
            
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.waveOffsetP = Angle(degrees: 540)
                self.waveOffsetB = Angle(degrees: 360)
            }
        }
    }
}

struct WaveP: Shape {
    
    var offSet: Angle
    var percentP: Double
    
    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newpercentP = lowestWave + (highestWave - lowestWave) * (percentP / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newpercentP) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct WaveB: Shape {
    
    var offSet: Angle
    var percentB: Double
    
    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newpercentP = lowestWave + (highestWave - lowestWave) * (percentB / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newpercentP) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct WaveAnimation_Previews: PreviewProvider {
    static var previews: some View {
        WaveAnimation()
    }
}
