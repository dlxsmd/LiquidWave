# LiquidWave 🌊

### Overview
LiquidWave is an advanced, highly customizable wave animation library for SwiftUI, inspired by the original [WaveAnimationView](https://github.com/noa4021J/WaveAnimationView) UIKit implementation.

#### Key Differences from Original WaveAnimationView
🔄 Transformed from UIKit to SwiftUI native implementation<br>
🎨 Enhanced customization options<br>
📱 Cross-platform support<br>
🌈 More flexible animation parameters<br>

## Installation
```swift
dependencies: [
    .package(url: "https://github.com/dlxsmd/LiquidWave.git", from: "1.0.0")
]
```

## Basic Usage
```swift
import LiquidWave

struct ContentView: View {
    @State private var waterLevel = 0.5

    var body: some View {
        WaveView(progress: $waterLevel)
    }
}
```

## Customization Example
```swift
WaveView(
    progress: $waterLevel,
    frontColor: .green,
    backColor: .blue,
    rippleColor: .white,
    floatingObject: AnyView(Image(systemName: "leaf.fill"))
)
```

## API Reference
### Wave Parameters
* `progress: Binding<CGFloat>`: Water level (0.0 - 1.0)
* `frontColor: Color`: Foreground wave color
* `backColor: Color`: Background wave color
* `gradient: Gradient`: Wave color gradient (default: [.blue, .cyan])
### Wave Animation
* `waveHeight: CGFloat`: Wave height (default: 0.04)
* `waveSpeed: Double`: Wave animation speed (default: 0.016)
### Floating Object
* `floatingObject: AnyView?`: Object displayed on the wave
* `floatingObjectSize: CGSize`: Floating object size (default: 50x50)
* `floatingAmplitude: CGFloat`: Vertical movement amplitude (default: 10)
### Ripple Effect
* `autoRippleEnabled: Bool`: Automatic ripple generation (default: true)
* `tapRippleEnabled: Bool`: Tap-based ripple generation (default: true)
* `rippleColor: Color`: Ripple color (default: .white)
* `rippleSize: CGFloat`: Maximum ripple size (default: 100)
* `rippleOpacity: CGFloat`: Ripple transparency (default: 0.5)
* `rippleDuration: Double`: Ripple animation duration (default: 2.0)
* `rippleInterval: Double`: Automatic ripple generation interval (default: 3.0)
### Mask
* `maskImage: Image?`: Mask image applied to the wave

## License
MIT License

