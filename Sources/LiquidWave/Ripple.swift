//
//  Ripple.swift
//  LiquidWave
//
//  Created by Yuki Imai on 2025/01/06.
//

import SwiftUI

struct RippleEffect: Shape {
    var center: CGPoint
    var progress: CGFloat
    var maxSize: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let radius = progress * maxSize / 2
        return Path(ellipseIn: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
    }
}



struct Ripple: Identifiable {
    let id = UUID()
    let center: CGPoint
    let color: Color
    var progress = CGFloat(0.0)
}
