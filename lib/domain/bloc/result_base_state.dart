
import 'package:equatable/equatable.dart';

abstract class ResultBaseState extends Equatable {

  final String? errorMsg;

  bool get isOk => errorMsg == null;
  bool get isError => !isOk;
  String getErrorMsg() => errorMsg ?? "";

  const ResultBaseState(this.errorMsg);

}