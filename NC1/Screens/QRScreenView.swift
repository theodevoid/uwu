//
//  QRScreenView.swift
//  NC1
//
//  Created by Theodore Mangowal on 26/04/24.
//

import SwiftUI
import QRCode

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
                    
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

struct QRScreenView: View {
    //    @State var qrImage
    var defaults = UserDefaults.standard
    @State private var isShowingCamera = false
    
    var body: some View {
        let userId = defaults.string(forKey: "userId")
        
        ZStack {
            Background()
            
            VStack(spacing: 40) {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 50))
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color("PastelPurple"))
                                .rotationEffect(Angle(degrees: 45))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 50))
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color("PastelPurple"))
                                .rotationEffect(Angle(degrees: 135))
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 50))
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color("PastelPurple"))
                                .rotationEffect(Angle(degrees: -45))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 50))
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color("PastelPurple"))
                                .rotationEffect(Angle(degrees: -135))
                        }
                    }
                    QRCodeShape(
                        text: userId!,
                        shape: QRCode.Shape(
                            onPixels: QRCode.PixelShape.Circle(),
                            eye: QRCode.EyeShape.Circle()
                        )
                    )?
                        .fill(Color("PastelDarkPurple"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 165, height: 165)
                }
                .frame(width: 230, height: 230)
                
                
                
                Button {
                    isShowingCamera = true
                } label: {
                    Image(systemName: "camera")
                        .font(.system(size: 20))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 24)
                        .background(
                            Color("PastelPurple")
                        )
                        .clipShape(Capsule())
                        .foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $isShowingCamera, content: {
                QRScanScreenView(isShowingScanner: $isShowingCamera)
            })
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    QRScreenView()
}
