import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var visible = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'styled_widget',
      home: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Switch.adaptive(
                value: visible,
                onChanged: (x) => setState(() => visible = x),
              ),
              SizedBox(
                height: 200,
                child: Center(
                  child: Placeholder(
                    child: StyledWidget(
                      style: (s) => s
                        ..marginAll()
                        ..paddingAll()
                        ..backgroundColor(Colors.black)
                        ..foregroundColor(Colors.white)
                        ..boxShadow(const BoxShadow(blurRadius: 8))
                        ..iconSize(24)
                        ..borderRadius(8)
                        ..animated(delay: const Duration(milliseconds: 500))
                        ..collapseY(!visible)
                        ..collapseX(!visible)
                        ..opacity(visible ? 1 : 0)
                        ..translate(y: visible ? 0 : 20)
                        ..rotate(visible ? 0 : 45)
                        ..fontSize(20)
                        ..fontFamily('courier')
                        ..fontWeight(FontWeight.bold)
                        ..rotateAlignment(Alignment.center),
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
