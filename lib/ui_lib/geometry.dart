part of rare_print;

class PrinterOffset {
  
  /// An offset with zero magnitude.
  ///
  /// This can be used to represent the origin of a coordinate space.
  static const PrinterOffset zero = PrinterOffset(0.0, 0.0);

  /// An offset with infinite x and y components.
  ///
  /// See also:
  ///
  ///  * [isInfinite], which checks whether either component is infinite.
  ///  * [isFinite], which checks whether both components are finite.
  // This is included for completeness, because [Size.infinite] exists.
  static const PrinterOffset infinite = PrinterOffset(double.infinity, double.infinity);

  final double? x;
  final double? y;

  const PrinterOffset(this.x, this.y);

    /// Returns a new offset with translateX added to the x component and
  /// translateY added to the y component.
  ///
  /// If the arguments come from another [PrinterOffset], consider using the `+` or `-`
  /// operators instead:
  ///
  /// ```dart
  /// PrinterOffset a = const PrinterOffset(10.0, 10.0);
  /// PrinterOffset b = const PrinterOffset(10.0, 10.0);
  /// PrinterOffset c = a + b; // same as: a.translate(b.x, b.y)
  /// PrinterOffset d = a - b; // same as: a.translate(-b.x, -b.y)
  /// ```
  PrinterOffset translate(double translateX, double translateY) => PrinterOffset(x! + translateX, y! + translateY);

  /// Unary negation operator.
  ///
  /// Returns an PrinterOffset with the coordinates negated.
  ///
  /// If the [PrinterOffset] represents an arrow on a plane, this operator returns the
  /// same arrow but pointing in the reverse direction.
  PrinterOffset operator -() => PrinterOffset(-x!, -y!);

  /// Binary subtraction operator.
  ///
  /// Returns an PrinterOffset whose [x] value is the left-hand-side operand's [x]
  /// minus the right-hand-side operand's [x] and whose [y] value is the
  /// left-hand-side operand's [y] minus the right-hand-side operand's [y].
  ///
  /// See also [translate].
  PrinterOffset operator -(PrinterOffset other) => PrinterOffset(x! - other.x!, y! - other.y!);

  /// Binary addition operator.
  ///
  /// Returns an PrinterOffset whose [x] value is the sum of the [x] values of the
  /// two operands, and whose [y] value is the sum of the [y] values of the
  /// two operands.
  ///
  /// See also [translate].
  PrinterOffset operator +(PrinterOffset other) => PrinterOffset(x! + other.x!, y! + other.y!);

  /// Multiplication operator.
  ///
  /// Returns an PrinterOffset whose coordinates are the coordinates of the
  /// left-hand-side operand (an PrinterOffset) multiplied by the scalar
  /// right-hand-side operand (a double).
  ///
  /// See also [scale].
  PrinterOffset operator *(double operand) => PrinterOffset(x! * operand, y! * operand);

  /// Division operator.
  ///
  /// Returns an PrinterOffset whose coordinates are the coordinates of the
  /// left-hand-side operand (an PrinterOffset) divided by the scalar right-hand-side
  /// operand (a double).
  ///
  /// See also [scale].
  PrinterOffset operator /(double operand) => PrinterOffset(x! / operand, y! / operand);

  /// Integer (truncating) division operator.
  ///
  /// Returns an PrinterOffset whose coordinates are the coordinates of the
  /// left-hand-side operand (an PrinterOffset) divided by the scalar right-hand-side
  /// operand (a double), rounded towards zero.
  PrinterOffset operator ~/(double operand) => PrinterOffset((x! ~/ operand).toDouble(), (y! ~/ operand).toDouble());

  /// Modulo (remainder) operator.
  ///
  /// Returns an PrinterOffset whose coordinates are the remainder of dividing the
  /// coordinates of the left-hand-side operand (an PrinterOffset) by the scalar
  /// right-hand-side operand (a double).
  PrinterOffset operator %(double operand) => PrinterOffset(x! % operand, y! % operand);

  PrinterRect operator &(PrinterSize other) => PrinterRect.fromLTWH(x ?? 0, y ?? 0, other.width ?? 0, other.height ?? 0);
}

class PrinterSize {
  /// An empty size, one with a zero width and a zero height.
  static const PrinterSize zero = PrinterSize(0.0, 0.0);

  /// A size whose [width] and [height] are infinite.
  ///
  /// See also:
  ///
  ///  * [isInfinite], which checks whether either dimension is infinite.
  ///  * [isFinite], which checks whether both dimensions are finite.
  static const PrinterSize infinite = PrinterSize(double.infinity, double.infinity);

  final double? width;
  final double? height;

  const PrinterSize(this.width, this.height);
}

class PrinterRect {

  const PrinterRect.fromLTRB(this.left, this.top, this.right, this.bottom)
      : assert(left != null), // ignore: unnecessary_null_comparison
        assert(top != null), // ignore: unnecessary_null_comparison
        assert(right != null), // ignore: unnecessary_null_comparison
        assert(bottom != null); // ignore: unnecessary_null_comparison

  /// Construct a rectangle from its left and top edges, its width, and its
  /// height.
  ///
  /// To construct a [PrinterRect] from an [Offset] and a [Size], you can use the
  /// rectangle constructor operator `&`. See [Offset.&].
  const PrinterRect.fromLTWH(double left, double top, double width, double height) : this.fromLTRB(left, top, left + width, top + height);

  
  /// The offset of the left edge of this rectangle from the x axis.
  final double left;

  /// The offset of the top edge of this rectangle from the y axis.
  final double top;

  /// The offset of the right edge of this rectangle from the x axis.
  final double right;

  /// The offset of the bottom edge of this rectangle from the y axis.
  final double bottom;

  double get width => right - left;
  double get height => bottom - top;

  bool isContain(PrinterOffset offset) {
    return this.left < offset.x! && this.top < offset.y!
          && this.right > offset.x! && this.bottom > offset.y!;
  } 
}

class PrinterConstraints {
  /// Creates box constraints with the given constraints.
  const PrinterConstraints({
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
  });

  PrinterConstraints.constraints(PrinterConstraints parentConstraints, PrinterSize size)
      : minWidth = parentConstraints.minWidth,
        minHeight = parentConstraints.minHeight,
        maxWidth = (size.width == null || size.width!.isInfinite) ? parentConstraints.maxWidth : size.width!,
        maxHeight = (size.height == null || size.height!.isInfinite) ? parentConstraints.maxHeight : size.height!;

  /// Creates box constraints that is respected only by the given size.
  PrinterConstraints.tight(PrinterSize size)
    : minWidth = size.width!,
      maxWidth = size.width!,
      minHeight = size.height!,
      maxHeight = size.height!;

  /// Creates box constraints that require the given width or height.
  ///
  /// See also:
  ///
  ///  * [new PrinterConstraints.tightForFinite], which is similar but instead of
  ///    being tight if the value is non-null, is tight if the value is not
  ///    infinite.
  const PrinterConstraints.tightFor({
    double? width,
    double? height,
  }) : minWidth = width ?? 0.0,
       maxWidth = width ?? double.infinity,
       minHeight = height ?? 0.0,
       maxHeight = height ?? double.infinity;

  /// Creates box constraints that require the given width or height, except if
  /// they are infinite.
  ///
  /// See also:
  ///
  ///  * [new PrinterConstraints.tightFor], which is similar but instead of being
  ///    tight if the value is not infinite, is tight if the value is non-null.
  const PrinterConstraints.tightForFinite({
    double width = double.infinity,
    double height = double.infinity,
  }) : minWidth = width != double.infinity ? width : 0.0,
       maxWidth = width != double.infinity ? width : double.infinity,
       minHeight = height != double.infinity ? height : 0.0,
       maxHeight = height != double.infinity ? height : double.infinity;

  /// Creates box constraints that forbid sizes larger than the given size.
  PrinterConstraints.loose(PrinterSize size)
    : minWidth = 0.0,
      maxWidth = size.width ?? double.infinity,
      minHeight = 0.0,
      maxHeight = size.height ?? double.infinity;

  /// Creates box constraints that expand to fill another box constraints.
  ///
  /// If width or height is given, the constraints will require exactly the
  /// given value in the given dimension.
  const PrinterConstraints.expand({
    double? width,
    double? height,
  }) : minWidth = width ?? double.infinity,
       maxWidth = width ?? double.infinity,
       minHeight = height ?? double.infinity,
       maxHeight = height ?? double.infinity;

  /// The minimum width that satisfies the constraints.
  final double minWidth;

  /// The maximum width that satisfies the constraints.
  ///
  /// Might be [double.infinity].
  final double maxWidth;

  /// The minimum height that satisfies the constraints.
  final double minHeight;

  /// The maximum height that satisfies the constraints.
  ///
  /// Might be [double.infinity].
  final double maxHeight;

  /// Creates a copy of this box constraints but with the given fields replaced with the new values.
  PrinterConstraints copyWith({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return PrinterConstraints(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }

  /// Returns the size that both satisfies the constraints and is as close as
  /// possible to the given size.
  ///
  /// See also:
  ///
  ///  * [constrainDimensions], which applies the same algorithm to
  ///    separately provided widths and heights.
  PrinterSize constrain(PrinterSize size) {
    PrinterSize result = PrinterSize(size.width == null ? null : constrainWidth(size.width!), size.height == null ? null : constrainHeight(size.height!));
    return result;
  }

    /// Returns the width that both satisfies the constraints and is as close as
  /// possible to the given width.
  double constrainWidth([ double width = double.infinity ]) {
    return width.clamp(minWidth, maxWidth);
  }

  /// Returns the height that both satisfies the constraints and is as close as
  /// possible to the given height.
  double constrainHeight([ double height = double.infinity ]) {
    return height.clamp(minHeight, maxHeight);
  }
}