import 'package:flutter/material.dart';
import '../state/ui_state.dart';

extension UiStateExtension<T> on UiState<T> {
  Widget when({
    required Widget Function() onLoading,
    required Widget Function(T data) onSuccess,
    required Widget Function(String message) onError,
    required Widget Function() onEmpty,
  }) {
    if (this is UiLoading<T>) {
      return onLoading();
    } else if (this is UiSuccess<T>) {
      return onSuccess((this as UiSuccess<T>).data);
    } else if (this is UiError<T>) {
      return onError((this as UiError<T>).message);
    } else if (this is UiEmpty<T>) {
      return onEmpty();
    }
    return onLoading();
  }
}
