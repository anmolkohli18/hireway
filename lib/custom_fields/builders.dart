import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

StreamBuilder withStreamBuilder<T>(
    {required Stream<T> stream, required Widget Function(T) widgetBuilder}) {
  return StreamBuilder<T>(
    stream: stream,
    builder: ((context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text(snapshot.error.toString()),
        );
      }

      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black45,
          ),
        );
      }

      final T documents = snapshot.requireData;
      return widgetBuilder(documents);
    }),
  );
}

FutureBuilder withFutureBuilder<T>(
    {required Future<T> future,
    required Widget Function(T) widgetBuilder,
    Widget emptyWidget = const Center(
      child: CircularProgressIndicator(
        color: Colors.black45,
      ),
    )}) {
  return FutureBuilder<T>(
      future: future,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData) {
          return emptyWidget;
        }

        final T documents = snapshot.requireData;
        return widgetBuilder(documents);
      }));
}
