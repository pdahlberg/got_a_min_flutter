
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

class CompressedSparseMatrix {

  int width;
  int height;
  List<int> rowPtrs = [];
  List<int> columns = [];
  List<int> values = [];
  int compressedValue;

  CompressedSparseMatrix(this.width, this.height, List<int> rowPtrs, List<int> columns, List<int> values, this.compressedValue) {
    var rowPtrsLen = rowPtrs.map((i) => i != compressedValue).toList().lastIndexOf(true);
    var columnsLen = columns.map((i) => i != compressedValue).toList().lastIndexOf(true);
    var valuesLen = values.map((i) => i != compressedValue).toList().lastIndexOf(true);
    var biggestLen = max(columnsLen, valuesLen);

    this.rowPtrs = rowPtrs.sublist(0, rowPtrsLen + 1);
    this.columns = columns.sublist(0, biggestLen + 1);
    this.values = values.sublist(0, biggestLen + 1);
  }

  static List<List<int>> initMatrix(int columns, int rows, int compressedValue) {
    List<List<int>> matrix = List.filled(columns, []);

    for (var x = 0; x < columns; x++) {
      matrix[x] = List.filled(rows, compressedValue);
    }

    return matrix;
  }

  void unpack(List<List<int>> targetMatrix, int startX, int startY) {
    var rp = rowPtrs[0];
    var rpNext = rowPtrs[1];
    var rpIdx = 0;
    for (var c = 0; c < columns.length; c++) {
      var x = columns[c];
      var v = values[c];

      if (rpIdx < rowPtrs.length) {
        rp = rowPtrs[rpIdx];
      }

      if (rpIdx + 1 < rowPtrs.length) {
        rpNext = rowPtrs[rpIdx + 1];
      } else {
        rpNext = rp;
      }

      if (c > 0 && c == rpNext) {
        rpIdx++;
      }

      var targetX = startX + x;
      var targetY = startY + rpIdx;

      targetMatrix[targetX][targetY] = v;
    }
  }

  bool exists(int x, int y) {
    var tuple = valuePtr(x, y);
    var i = tuple.item1;
    if (i >= 0) {
      return get(x, y) != compressedValue;
    } else {
      return false;
    }
  }

  int get(int x, int y) {
    var r = compressedValue;
    var tuple = valuePtr(x, y);
    var i = tuple.item1;
    if (i >= 0) {
      r = values[i];
    }
    return r;
  }

  put(int x, int y, int newValue) {
    var r = 0;
    var tuple = valuePtr(x, y);
    var i = tuple.item1;
    var insertPoint = tuple.item2;
    if (i >= 0) {
      values[i] = newValue;
    } else {
      if (insertPoint >= 0) {
        columns.insert(insertPoint, x);
        values.insert(insertPoint, newValue);

        if (y < rowPtrs.length) {
          var rpValNext = columns.length;
          if (y + 1 < rowPtrs.length) {
            rpValNext = rowPtrs[y + 1];
          }
          for (var i = y + 1; i < rowPtrs.length; i++) {
            var newRpVal = rowPtrs[i] + 1;
            rowPtrs.replaceRange(i, i + 1, [newRpVal]);
          }
        }

        if (x >= width) {
          width = x + 1;
        }
      } else {
        var xDiff = (x + 1) - width;
        if (xDiff > 0) {
          width += xDiff;
        }

        var yDiff = (y + 1) - height;

        for (var addY = height; addY < y + 1; addY++) {
          rowPtrs.add(columns.length);
          columns.add(0);
          values.add(0);
        }

        if (yDiff > 0) {
          rowPtrs.add(columns.length);
          columns.add(x);
          values.add(newValue);
          height += yDiff;
        }
      }
    }
    return r;
  }

  Tuple2<int, int> valuePtr(int x, int y) {
    var valueIndex = -1;
    var insertPoint = -1;
    if (y < rowPtrs.length) {
      var rpVal = rowPtrs[y];
      var rpValNext = columns.length;
      if (y + 1 < rowPtrs.length) {
        rpValNext = rowPtrs[y + 1];
      }
      var checkColSubset = false;
      var xInColumn = 0;
      //var colSubset = "";
      for (var colSubsetPos = rpVal; colSubsetPos < rpValNext; colSubsetPos++) {
        //colSubset += this.columns[colSubsetPos];
        if (x == columns[colSubsetPos]) {
          xInColumn = colSubsetPos;
          checkColSubset = true;
          break;
        } else if (x < columns[colSubsetPos]) {
          insertPoint = colSubsetPos;
          break;
        } else if (colSubsetPos == rpValNext - 1) {
          //console.log("colSubsetPos end: ", colSubsetPos);
          insertPoint = colSubsetPos + 1;
        }
      }

      var checkMinimum = xInColumn >= 0 && checkColSubset;
      var checkMaxPerRowOrEnd = (xInColumn <= rpValNext);
      if (checkMinimum && checkMaxPerRowOrEnd) {
        var c = xInColumn;
        if (c < values.length) {
          valueIndex = c;
        }
      }
      //console.log("valueIndex", valueIndex, "rpVal", rpVal, "x2", x2, "colSubset", colSubset);
    }
    return Tuple2(valueIndex, insertPoint);
  }

  String asMatrixToString() {
    var matrix = CompressedSparseMatrix.initMatrix(width, height, compressedValue);
    unpack(matrix, 0, 0);

    var str = "";
    for (var y = 0; y < matrix[0].length; y++) {
      for (var x = 0; x < matrix.length; x++) {
        str += "${matrix[x][y]}";
      }
      str += "\n";
    }
    return str;
  }

  String debugCompressedAsString() {
    var lines = "$width x $height\n";
    lines += "rowPtr: ";
    rowPtrs.forEach((a) { lines += a.toString(); });
    lines += "\n";
    lines += "col: ";
    columns.forEach((a) { lines += a.toString(); });
    lines += "\n";
    lines += "val: ";
    values.forEach((a) { lines += a.toString(); });
    return lines;
  }

}

