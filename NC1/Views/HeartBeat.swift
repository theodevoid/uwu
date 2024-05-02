//
//  HeartBeat.swift
//  CoreHaptic
//
//  Created by Stevans Calvin Candra on 26/04/24.
//

import SwiftUI
import CoreHaptics
import AVFoundation

struct HeartBeat: View {
    var bpm: Double = 60.0
    
    @State var beating = false
    @State var hapticsBeat = false
    
    @State var engineRestart = false
    @State var engine: CHHapticEngine?
    @State var player: CHHapticAdvancedPatternPlayer?
    
    @State var timer: Timer?
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
                .frame(width: 150, height: 150)
                .padding(25)
            
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.pink)
                .frame(width: 75)
                .scaleEffect(beating ? 1.25 : 1)
                .offset(CGSize(width: 55.0, height: 55.0))
                .padding()
                .onAppear(perform: runHeartAnimation)
        }
        .contentShape(Circle())
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: 300) { onHold in
            if onHold {
                stopHeart()
                runHeartAnimation()
                runBeat()
            } else {
                stopBeat()
            }
        } perform: {}
        .onChange(of: bpm) {
            stopHeart()
            runHeartAnimation()
            
            if hapticsBeat {
                stopBeat()
                runBeat()
            }
        }
    }
    
    
    func calculateBeat() -> Double {
        return 60/(bpm*3)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        if engine == nil {
            do {
                engine = try CHHapticEngine(audioSession: .sharedInstance())
            } catch {
                print("There was an error creating the engine: \(error.localizedDescription)")
            }
            
            engine?.stoppedHandler = { reason in
                print("The Engine Stopped due to \(reason.rawValue)")
                engineRestart = true
            }
            
            engine?.resetHandler = {
                print("The Engine Restarting now")
                engineRestart = true
            }
            
            do {
                try engine?.start()
            } catch {
                print("Failed in Starting the Engine: \(error.localizedDescription) ")
            }
        }
    }
    
    func restartEngineIfNeeded() {
        if engineRestart {
            do {
                try engine?.start()
            } catch {
                print("Failed in Starting the Engine: \(error.localizedDescription) ")
            }
            engineRestart = false
        }
    }
    
    func runBeat() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        prepareHaptics()
        restartEngineIfNeeded()
        
        var events = [CHHapticEvent]()
        
        for i in 1...3 {
            let time: Double = calculateBeat() * Double(i)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: i == 3 ? 0 : 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: i == 3 ? 0 : 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: time)
            events.append(event)
            
            if i != 3 {
                let audioEvent = CHHapticEvent(audioResourceID: prepareAudio(i), parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: 1.0)
                    ], relativeTime: time)
                events.append(audioEvent)
            }
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            
            if !hapticsBeat {
                player = try engine?.makeAdvancedPlayer(with: pattern)
                try player?.start(atTime: 0)
                player?.loopEnabled = true
                hapticsBeat = true
            }
            
        } catch {
            print("Failed to play pattern \(error.localizedDescription)")
        }
    }
    
    func stopBeat() {
        do {
            try player?.stop(atTime: 0)
            hapticsBeat = false
        } catch {
            print("Error in Stopping Haptics \(error.localizedDescription)")
        }
    }
    
    func prepareAudio(_ curr: Int) -> CHHapticAudioResourceID {
        let beat1stURL = Bundle.main.url(forResource: "Beat1st", withExtension: "wav")!
        let beat2ndURL = Bundle.main.url(forResource: "Beat2nd", withExtension: "wav")!
        
        let beat1stID = (try! engine?.registerAudioResource(beat1stURL, options: [:]))!
        let beat2ndID = (try! engine?.registerAudioResource(beat2ndURL, options: [:]))!
        
        if curr == 1 {
            return beat1stID
        } else {
            return beat2ndID
        }
    }
    
    func runHeartAnimation() {
        withAnimation(.easeInOut(duration: calculateBeat())) {
            beating = true
        } completion: {
            withAnimation(.easeInOut(duration: calculateBeat())) {
                beating = false
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: calculateBeat()*3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: calculateBeat())) {
                beating = true
            } completion: {
                withAnimation(.easeInOut(duration: calculateBeat())) {
                    beating = false
                }
            }
        }
    }
    
    func stopHeart() {
        timer?.invalidate()
        timer = nil
    }
    
    func beatFromProfile() {
        hapticsBeat = true
        runBeat()
    }
    
    func stopProfileBeat() {
        hapticsBeat = false
        stopBeat()
    }
    
}


#Preview {
    HeartBeat()
}
