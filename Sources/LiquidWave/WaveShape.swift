//
//  WaveShape.swift
//  LiquidWave
//
//  Created by Yuki Imai on 2025/01/06.
//

import SwiftUI

public struct WaveShape: Shape {
    public var progress: CGFloat // 水位（0.0 ～ 1.0）
    public var waveHeight: CGFloat // 波の高さ（0.0 ～ 1.0 推奨）
    public var phase: CGFloat // 波の位相

    public init(progress: CGFloat, waveHeight: CGFloat, phase: CGFloat) {
        self.progress = progress
        self.waveHeight = waveHeight
        self.phase = phase
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midY = height * (1 - progress)

        path.move(to: CGPoint(x: 0, y: midY))

        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin(relativeX * .pi * 2 + phase)
            let y = midY + sine * waveHeight * height
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }
}
