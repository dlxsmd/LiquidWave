# LiquidWave 🌊

### 概要
LiquidWaveは、元の[WaveAnimationView](https://github.com/noa4021J/WaveAnimationView)のUIKit実装からインスピレーションを得た、SwiftUI用の高度にカスタマイズ可能な波アニメーションライブラリです。

#### オリジナルとの主な違い
🔄 UIKitからSwiftUIネイティブ実装への変革<br>
🎨 拡張されたカスタマイズオプション<br>
📱 クロスプラットフォームサポート<br>
🌈 より柔軟なアニメーションパラメータ<br>

## インストール
```swift
dependencies: [
    .package(url: "https://github.com/dlxsmd/LiquidWave.git", from: "1.0.0")
]
```

## 基本的な使用方法
```swift
import LiquidWave

struct ContentView: View {
    @State private var waterLevel = 0.5

    var body: some View {
        WaveView(progress: $waterLevel)
    }
}
```

## カスタマイズ例
```swift
WaveView(
    progress: $waterLevel,
    frontColor: .green,
    backColor: .blue,
    rippleColor: .white,
    floatingObject: AnyView(Image(systemName: "leaf.fill"))
)
```

## APIリファレンス
### 波の基本設定
* `progress: Binding<CGFloat>`: 水位（0.0 ～ 1.0）
* `frontColor: Color`: 前景波の色
* `backColor: Color`: 背景波の色
* `gradient: Gradient`: 波のグラデーション（デフォルト: [.blue, .cyan]）
### 波のアニメーション
* `waveHeight: CGFloat`: 波の高さ（デフォルト: 0.04）
* `waveSpeed: Double`: 波のアニメーション速度（デフォルト: 0.016）
### 浮遊オブジェクト
* `floatingObject: AnyView?`: 波の上に表示するオブジェクト
* `floatingObjectSize: CGSize`: 浮遊オブジェクトのサイズ（デフォルト: 50x50）
* `floatingAmplitude: CGFloat`: 浮遊オブジェクトの上下移動量（デフォルト: 10）
### 波紋エフェクト
* `autoRippleEnabled: Bool`: 自動波紋の有効/無効（デフォルト: true）
* `tapRippleEnabled: Bool`: タップ時の波紋の有効/無効（デフォルト: true）
* `rippleColor: Color`: 波紋の色（デフォルト: .white）
* `rippleSize: CGFloat`: 波紋の最大サイズ（デフォルト: 100）
* `rippleOpacity: CGFloat`: 波紋の透明度（デフォルト: 0.5）
* `rippleDuration: Double`: 波紋のアニメーション時間（デフォルト: 2.0）
* `rippleInterval: Double`: 自動波紋の生成間隔（デフォルト: 3.0）
### マスク
* `maskImage: Image?`: 波に適用するマスク画像

## ライセンス
MITライセンス
