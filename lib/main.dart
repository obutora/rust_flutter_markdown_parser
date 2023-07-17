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
              print('Large Data -----------------');
              final measure = Measure(
                  Markdown.markdownToHtml, api.markdownToHtml, rawData, 100);
              await measure.record();

              print('-----------------');

              final largeMeasure = Measure(
                  Markdown.markdownToHtml, api.markdownToHtml, rawData, 1000);
              await largeMeasure.record();

              print('light Data -----------------');

              final lightMeasure = Measure(Markdown.markdownToHtml,
                  api.markdownToHtml, lightRawData, 100);
              await lightMeasure.record();

              print('-----------------');

              final lightManyMeasure = Measure(Markdown.markdownToHtml,
                  api.markdownToHtml, lightRawData, 1000);
              await lightManyMeasure.record();

              print('MyData -----------------');

              final myMeasyre = Measure(
                  Markdown.markdownToHtml, api.markdownToHtml, myRawData, 100);
              await myMeasyre.record();

              print('-----------------');

              final myMeasyre2 = Measure(
                  Markdown.markdownToHtml, api.markdownToHtml, myRawData, 100);
              await myMeasyre2.record();
              // final hello = await api.hello();
              // final m = await api.markdownToHtml(markdown: 'Hello');
              // print(m);
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
