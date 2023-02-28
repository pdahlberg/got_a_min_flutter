import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:got_a_min_flutter/domain/model/compressed_sparse_matrix.dart';

import 'package:got_a_min_flutter/main.dart';

void main() {

  test('CSM', () async {
    final rowPtrs = "0248".characters.toList().map((char) => int.parse(char)).toList();
    final columns = "2312012512345".characters.toList().map((char) => int.parse(char)).toList();
    final values = "3121421351421".characters.toList().map((char) => int.parse(char)).toList();
    final csm = CompressedSparseMatrix(6, 5, rowPtrs, columns, values, 0);

    final str = csm.asMatrixToString();
    debugPrint("CSM:\n$str");
    debugPrint("\n${csm.debugCompressedAsString()}");
  });

}
