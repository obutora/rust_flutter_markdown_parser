import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as Markdown;
import 'package:rust_flutter_markdown_parser/markdown/raw_data.dart';
import 'package:rust_flutter_markdown_parser/rust.dart';

import 'measure/measure.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              //161ms
              // final dartMeasure = Measure(
              //   Markdown.markdownToHtml,
              //   api.markdownToHtml,
              //   rawData,
              //   100,
              // );
              // await dartMeasure.recordDart();

              // myData
              //64ms
              final rustMeasure = Measure(
                Markdown.markdownToHtml,
                api.markdownToHtml,
                rawData,
                100,
              );
              await rustMeasure.recordRust();
            },
            child: const Text('Markdown Test By Dart'),
          ),
          // child: FutureBuilder(
          //   future: api.helloWorld(), // ここでRustのAPIを呼び出す
          //   builder: (context, AsyncSnapshot<String> data) {
          //     if (data.hasData) {
          //       return Text(data.data!); // The string to display
          //     }
          //     return const Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
