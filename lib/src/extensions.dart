extension TypedGetter on Map {
  T getAs<T>(String key, {T Function()? orGet}) {
    if (containsKey(key)) {
      final val = this[key];
      if (val is T) return val;
      throw FormatException('Expected $T, found ${val.runtimeType}');
    }
    if (orGet != null) return orGet();
    throw FormatException('Key "$key" does not exist');
  }
}
