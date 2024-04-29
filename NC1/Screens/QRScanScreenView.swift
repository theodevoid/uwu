//
//  QRScanScreenView.swift
//  NC1
//
//  Created by Theodore Mangowal on 26/04/24.
//

import SwiftUI
import CodeScanner
import QRCode

func HoleShapeMask(in rect: CGRect) -> Path {
    var shape = Rectangle().path(in: rect)
    shape.addPath(Circle().path(in: rect))
    return shape
}

struct QRScanScreenView: View {
    @Binding var isShowingScanner: Bool
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        // more code to come
        switch result {
        case .success(let result):
            print(result.string)
        case .failure(_):
            print("failed")
        }
    }
    
    let rect = CGRect(x: 0, y: 0, width: 300, height: 100)
    
    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr], completion: handleScan)
            
            ZStack {
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
                        //                    CodeScannerView(codeTypes: [.qr], completion: handleScan)
                        //                        .fill(Color("PastelDarkPurple"))
                        //                        .aspectRatio(contentMode: .fit)
                        //                        .frame(width: 165, height: 165)
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 210, height: 210)
                            .compositingGroup()
                            .luminanceToAlpha()
                    }
                    .frame(width: 230, height: 230)
                }
                
                Rectangle()
                    .fill(.black)
                    .opacity(0.3)
                
            }
            
        }
        
    }
}

//#Preview {
//    QRScanScreenView(isShowingScanner: )
//}
