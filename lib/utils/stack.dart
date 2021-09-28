import 'dart:collection';

class Stack<T> {
  final _stack = Queue<T>();

  void push(T element) {
    _stack.addLast(element);
  }

  T pop() {
    final T lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }

  void clear() {
    _stack.clear();
  }

  int get length => _stack.length;

  bool get isEmpty => _stack.isEmpty;

  T get top => _stack.last;
}
