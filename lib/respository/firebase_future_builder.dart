import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/respository/firestore_database.dart';
import 'package:hireway/main.dart';

class FirebaseFutureBuilder<T> extends ConsumerWidget {
  const FirebaseFutureBuilder(
      {super.key, required this.dataStream, required this.widgetBuilder});

  final Stream<QuerySnapshot<T>> Function(String) dataStream;
  final Widget Function(List<QueryDocumentSnapshot<T>>) widgetBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreDatabase firestoreDb = ref.watch(firestoreProvider)!;
    return FutureBuilder<String?>(
        future: ref.watch(firestoreDb.businessNameProvider().future),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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

          String businessName = snapshot.data!;
          return StreamBuilder<QuerySnapshot<T>>(
            stream: dataStream(businessName),
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

              final List<QueryDocumentSnapshot<T>> documents =
                  snapshot.data!.docs;
              return widgetBuilder(documents);
            }),
          );
        });
  }
}
