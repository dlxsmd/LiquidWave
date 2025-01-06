import XCTest
import SwiftUI
@testable import LiquidWave

class LiquidWaveTests: XCTestCase {
    func testWaveViewInitialization() async throws {
        await MainActor.run {
            let progress = CGFloat(0.5)
            let waveView = WaveView(progress: .constant(progress))
            
            XCTAssertEqual(waveView.$progress.wrappedValue, 0.5)
            XCTAssertEqual(waveView.frontColor, .blue)
            XCTAssertEqual(waveView.backColor, .cyan)
        }
    }
    
    func testWaveViewCustomization() async {
        await MainActor.run {
            let waveView = WaveView(
                progress: .constant(0.7),
                frontColor: .green,
                backColor: .blue,
                rippleColor: .red,
                rippleSize: 150,
                rippleOpacity: 0.7
            )
            
            XCTAssertEqual(waveView.frontColor, .green)
            XCTAssertEqual(waveView.backColor, .blue)
            XCTAssertEqual(waveView.rippleColor, .red)
            XCTAssertEqual(waveView.rippleSize, 150)
            XCTAssertEqual(waveView.rippleOpacity, 0.7)
        }
    }

    func testRippleEffectToggle() async {
        await MainActor.run {
            let waveView = WaveView(
                progress: .constant(0.5),
                autoRippleEnabled: false,
                tapRippleEnabled: false
            )
            
            XCTAssertFalse(waveView.autoRippleEnabled)
            XCTAssertFalse(waveView.tapRippleEnabled)
        }
    }

    func testFloatingObject() async {
        await MainActor.run {
            let boatImage = Image(systemName: "leaf.fill")
            let waveView = WaveView(
                progress: .constant(0.5),
                floatingObject: AnyView(boatImage),
                floatingObjectSize: CGSize(width: 100, height: 50)
            )
            
            XCTAssertNotNil(waveView.floatingObject)
            XCTAssertEqual(waveView.floatingObjectSize, CGSize(width: 100, height: 50))
        }
    }

    func testWaveParameters() async {
        await MainActor.run {
            let waveView = WaveView(
                progress: .constant(0.6),
                waveHeight: 0.08,
                waveSpeed: 0.02
            )
            
            XCTAssertEqual(waveView.waveHeight, 0.08)
            XCTAssertEqual(waveView.waveSpeed, 0.02)
        }
    }
}
