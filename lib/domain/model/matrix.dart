
class Matrix {

  final List<List<int>> matrix;
  final int width;
  final int height;
  final int emptyValue;

  Matrix._(this.matrix, this.width, this.height, this.emptyValue);

  Matrix.empty({
    this.width = 0,
    this.height = 0,
    this.emptyValue = 0,
  }) : matrix = _init(width, height, 0);

  Matrix.of(List<List<int>> matrixData, { int emptyValue = 0 }) :
        this._(matrixData, matrixData.length, matrixData.length, emptyValue);

  static List<List<int>> _init(int columns, int rows, int compressedValue) {
    List<List<int>> matrix = List.filled(columns, []);

    for (var x = 0; x < columns; x++) {
      matrix[x] = List.filled(rows, compressedValue);
    }

    return matrix;
  }

  void set(int x, int y, int value) {
    matrix[x][y] = value;
  }

  @override
  String toString({ int indent = 0 }) {
    final indentStr = List.filled(indent, " ").join();
    var str = indentStr;
    for (var y = 0; y < matrix[0].length; y++) {
      for (var x = 0; x < matrix.length; x++) {
        str += "${matrix[x][y]}";
      }
      str += "\n$indentStr";
    }
    return str;
  }

}