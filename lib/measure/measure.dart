import 'dart:math' as Math;

enum MeasureType { dart, rust }

class Measure {
  int index = 0;
  List<int> durationMilliseconds = [];
  String dartMarkdownResult = '';
  String rustMarkdownResult = '';

  final String markdownText;
  final String Function(String) dartMarkdownToHtml;
  final Future<String> Function({required String markdown, dynamic hint})
      rustMarkdownToHtml;
  final int tryNum;

  Measure(this.dartMarkdownToHtml, this.rustMarkdownToHtml, this.markdownText,
      this.tryNum);

  Future<void> record() async {
    await measure(MeasureType.dart);
    await measure(MeasureType.rust);
  }

  Future<void> measure(MeasureType type) async {
    measureStart(type);

    while (index < tryNum) {
      final preTime = DateTime.now();

      switch (type) {
        case MeasureType.dart:
          dartMarkdownResult = dartMarkdownToHtml(markdownText);
          break;
        case MeasureType.rust:
          rustMarkdownResult = await rustMarkdownToHtml(markdown: markdownText);
          break;
      }

      final postTime = DateTime.now();
      final diff = postTime.difference(preTime).inMicroseconds;
      durationMilliseconds.add(diff);

      index++;
    }
    printAverageTime();
    printMaxTime();
    printMinTime();

    printMarkdownResult(type);
    reset();
  }

  void measureStart(MeasureType type) {
    switch (type) {
      case MeasureType.dart:
        print('dart Measure start -----------------');
        break;
      case MeasureType.rust:
        print('rust Measure start -----------------');
        break;
    }
  }

  void reset() {
    index = 0;
    durationMilliseconds = [];
    dartMarkdownResult = '';
    rustMarkdownResult = '';
  }

  void printAverageTime() {
    final average = durationMilliseconds.reduce((a, b) => a + b) /
        durationMilliseconds.length;
    print('average time: $average μs');
  }

  void printMaxTime() {
    final max = durationMilliseconds.reduce(Math.max);
    print('max time: $max μs');
  }

  void printMinTime() {
    final min = durationMilliseconds.reduce(Math.min);
    print('min time: $min μs');
  }

  void printMarkdownResult(MeasureType type) {
    switch (type) {
      case MeasureType.dart:
        print('dart result: ${dartMarkdownResult.length}');
        break;
      case MeasureType.rust:
        print('rust result: ${rustMarkdownResult.length}');
        break;
    }
  }
}
