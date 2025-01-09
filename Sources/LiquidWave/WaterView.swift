//
//  WaveView.swift
//  LiquidWave
//
//  Created by Yuki Imai on 2025/01/06.
//

import SwiftUI
import Combine

public enum WaveFillStyle {
    case solid(Color)
    case gradient(Gradient)
}

public struct WaveView: View {
    // 水位（0.0 ～ 1.0）
    @Binding public var progress: CGFloat
    
    // 波の色
    public var frontFillStyle: WaveFillStyle = .solid(.blue)
    public var backFillStyle: WaveFillStyle = .solid(.cyan)
    
    // マスク画像
    public var maskImage: Image?
    
    // 浮遊オブジェクト
    public var floatingObject: AnyView? = nil
    public var floatingObjectSize: CGSize = CGSize(width: 50, height: 50)
    public var floatingAmplitude: CGFloat = 10 // 浮遊オブジェクトの上下移動量

    
    // Rippleエフェクト
    public var autoRippleEnabled: Bool = true
    public var rippleColor: Color = .white
    public var rippleSize: CGFloat = 100
    public var rippleOpacity: CGFloat = 0.5
    public var rippleDuration: Double = 2.0
    public var rippleInterval: Double = 3.0
    public var tapRippleEnabled: Bool = true
    
    // 波の設定
    public var waveHeight: CGFloat = 0.04 // 波の高さ
    public var waveSpeed: Double = 0.016 // 波の更新間隔(60FPS)
    
    @State private var phase1: CGFloat = 0.0 // 波1の位相
    @State private var phase2: CGFloat = 0.0 // 波2の位相
    @State private var targetPhase1: CGFloat = 0.0 // 波1の目標位相
    @State private var targetPhase2: CGFloat = 0.0 // 波2の目標位相
    @State private var ripples: [Ripple] = []
    @State private var rippleAnimationCancellable: AnyCancellable?
    @State private var waveAnimationCancellable: AnyCancellable?
    
    public init(progress: Binding<CGFloat>,
                frontFillStyle: WaveFillStyle = .solid(.blue),
                backFillStyle: WaveFillStyle = .solid(.cyan),
                maskImage: Image? = nil,
                floatingObject: AnyView? = nil,
                floatingObjectSize: CGSize = CGSize(width: 50, height: 50),
                floatingAmplitude: CGFloat = 10,
                autoRippleEnabled: Bool = true,
                rippleColor: Color = .white,
                rippleSize: CGFloat = 100,
                rippleOpacity: CGFloat = 0.5,
                rippleDuration: Double = 2.0,
                rippleInterval: Double = 3.0,
                tapRippleEnabled: Bool = true,
                waveHeight: CGFloat = 0.04,
                waveSpeed: Double = 0.016) {
        self._progress = progress
        self.frontFillStyle = frontFillStyle
        self.backFillStyle = backFillStyle
        self.maskImage = maskImage
        self.floatingObject = floatingObject
        self.floatingObjectSize = floatingObjectSize
        self.floatingAmplitude = floatingAmplitude
        self.autoRippleEnabled = autoRippleEnabled
        self.rippleColor = rippleColor
        self.rippleSize = rippleSize
        self.rippleOpacity = rippleOpacity
        self.rippleDuration = rippleDuration
        self.rippleInterval = rippleInterval
        self.tapRippleEnabled = tapRippleEnabled
        self.waveHeight = waveHeight
        self.waveSpeed = waveSpeed
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                WaveShape(progress: progress, waveHeight: waveHeight * 0.5, phase: phase1)
                    .fill(applyFillStyle(backFillStyle))
                    .opacity(0.6)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut(duration: 0.3), value: progress)

                WaveShape(progress: progress, waveHeight: waveHeight, phase: phase2)
                    .fill(applyFillStyle(frontFillStyle))
                    .opacity(0.8)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut(duration: 0.3), value: progress)
                
                if let floatingObject {
                    let offsetY = -floatingAmplitude * sin(phase1)
                    let positionY = geometry.size.height * (1 - progress)

                    floatingObject
                        .frame(width: floatingObjectSize.width, height: floatingObjectSize.height)
                        .offset(y: offsetY)
                        .position(x: geometry.size.width / 2, y: positionY)
                        .animation(
                            .spring(
                                response: 0.5,
                                dampingFraction: 0.6,
                                blendDuration: 0.3
                            ),
                            value: progress
                        )
                }

                if autoRippleEnabled || tapRippleEnabled {
                    ForEach(ripples) { ripple in
                        let rippleOpacityValue = rippleOpacity * (1 - ripple.progress)

                        RippleEffect(center: ripple.center, progress: ripple.progress, maxSize: rippleSize)
                            .stroke(ripple.color.opacity(rippleOpacityValue), lineWidth: 2)
                            .animation(.easeOut(duration: rippleDuration), value: ripple.progress)
                    }
                }
            }
            .drawingGroup()
            .mask(
                Group {
                    if let maskImage = maskImage {
                        maskImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        Rectangle()
                    }
                }
            )
            .onAppear {
                startWaveAnimation()

                if autoRippleEnabled {
                    startAutoRipples(in: geometry.size)
                }
            }
            .onDisappear {
                rippleAnimationCancellable?.cancel()
                rippleAnimationCancellable = nil
                waveAnimationCancellable?.cancel()
                waveAnimationCancellable = nil
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { gesture in
                        let location = gesture.location
                        if tapRippleEnabled {
                            addRipple(at: location)
                        }
                    }
            )
        }
    }
    
    private func smoothPhaseUpdate(_ currentPhase: CGFloat, targetPhase: CGFloat) -> CGFloat {
        return currentPhase + (targetPhase - currentPhase) * 0.1
    }
    
    private func startWaveAnimation() {
        Timer.scheduledTimer(withTimeInterval: waveSpeed, repeats: true) { _ in
            Task { @MainActor in
                targetPhase1 += 0.05
                targetPhase2 += 0.03

                phase1 = smoothPhaseUpdate(phase1, targetPhase: targetPhase1)
                phase2 = smoothPhaseUpdate(phase2, targetPhase: targetPhase2)
            }
        }
    }

    private func startAutoRipples(in size: CGSize) {
        rippleAnimationCancellable = Timer.publish(every: rippleInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [self] _ in
                let randomX = CGFloat.random(in: 0...size.width)
                let randomY = CGFloat.random(in: 0...size.height * (1 - progress))
                
                addRipple(at: CGPoint(x: randomX, y: randomY))
            }
    }

    private func addRipple(at location: CGPoint) {
        if ripples.count > 10 {
            ripples.removeFirst()
        }
        
        let ripple = Ripple(center: location, color: rippleColor, progress: 0.0)
        ripples.append(ripple)

        withAnimation(.easeOut(duration: rippleDuration)) {
            if let index = ripples.firstIndex(where: { $0.id == ripple.id }) {
                ripples[index].progress = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + rippleDuration) {
            ripples.removeAll { $0.id == ripple.id }
        }
    }
    
    private func applyFillStyle(_ fillStyle: WaveFillStyle) -> AnyShapeStyle {
        switch fillStyle {
        case .solid(let color):
            return AnyShapeStyle(color)
        case .gradient(let gradient):
            return AnyShapeStyle(
                LinearGradient(
                    gradient: gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

