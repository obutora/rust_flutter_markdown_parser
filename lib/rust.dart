import 'dart:ffi';
import 'dart:io' as io;

// flutter_rust_bridge_codegenで生成された、bridge_generated.dartをimport
import 'package:rust_flutter_markdown_parser/bridge_generated.dart';

const _base = 'native';
// const target = '../rust/target/debug/';

final _dylib = io.Platform.isWindows ? '$_base.dll' : 'lib$_base.so';

// RustのAPIを呼び出すためのインスタンスを生成
// RustImplはbridge_generated.dartで生成されたクラス
final api = NativeImpl(io.Platform.isIOS || io.Platform.isMacOS
    ? DynamicLibrary.executable()
    : DynamicLibrary.open(_dylib));
