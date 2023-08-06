import 'dart:math' as Math;
import 'dart:developer' as developer;

import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

enum MeasureType { dart, rust }

class Measure {
  int index = 0;
  List<int> durationMilliseconds = [];
  String dartMarkdownResult = '';
  String rustMarkdownResult = '';
  List<int> memoryUsageList = [];

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

  Future<void> recordDart() async => await measure(MeasureType.dart);
  Future<void> recordRust() async => await measure(MeasureType.rust);

  Future<MemoryUsage> getMemoryUsage() async {
    developer.ServiceProtocolInfo info = await developer.Service.getInfo();
    VmService service =
        await vmServiceConnectUri(info.serverWebSocketUri.toString());
    VM vm = await service.getVM();
    String? isolateId = vm.isolates?.first.id;
    MemoryUsage mem;
    if (isolateId == null) {
      mem = MemoryUsage(externalUsage: 0, heapCapacity: 0, heapUsage: 0);
    } else {
      mem = await service.getMemoryUsage(isolateId);
    }
    return mem;
  }

  Future<double> getMemoryUsagePercentage() async {
    MemoryUsage mem = await getMemoryUsage();
    return 100 * mem.heapUsage! / mem.heapCapacity!;
  }

  Future<int> getExternalUsage() async {
    MemoryUsage mem = await getMemoryUsage();
    return mem.externalUsage!;
  }

  Future<void> measure(MeasureType type) async {
    measureStart(type);
    // final sys = await api.systemInfo();
    // print('memory usage: ${sys} %');
    print('memory usage: ${await getExternalUsage()}');
    // final preMemUsage = await getMemoryUsagePercentage();
    // print('pre Memory Usage : ${preMemUsage.toStringAsFixed(1)} %');

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

      final mem = await getExternalUsage();
      memoryUsageList.add(mem);

      index++;
    }

    print('memory usage: ${await getExternalUsage()}');

    // final postMemUsage = await getMemoryUsagePercentage();
    // print('post Memory Usage : ${postMemUsage.toStringAsFixed(1)} %');

    // print(
    //     'diff Memory Usage : ${(postMemUsage - preMemUsage).toStringAsFixed(1)} %');

    printAverageTime();
    printMaxTime();
    printMinTime();

    print(memoryUsageList);

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
}
