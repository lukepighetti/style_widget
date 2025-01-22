# style_widget

https://github.com/lukepighetti/style_widget/blob/main/example/lib/main.dart#L35-L73

idea from: https://x.com/luke_pighetti/status/1882101453571154076

```dart
StyleWidget(
  style: (s) => s
      .marginAll()
      .paddingAll()
      .backgroundColor(Colors.black)
      .foregroundColor(Colors.white)
      .boxShadow(const BoxShadow(blurRadius: 8))
      .iconSize(24)
      .borderRadius(8)
      .animated(delay: const Duration(milliseconds: 500))
      .collapseY(!visible)
      .collapseX(!visible)
      .opacity(visible ? 1 : 0)
      .translate(y: visible ? 0 : 20)
      .rotate(visible ? 0 : 45)
      .fontSize(20)
      .fontFamily('courier')
      .fontWeight(FontWeight.bold)
      .rotateAlignment(Alignment.center),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text("Hello"),
      const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          Text("Subtitle"),
        ],
      ),
      FilledButton(
        child: const Text("Continue"),
        onPressed: () {
          print("boom");
        },
      )
    ],
  ),
);
```