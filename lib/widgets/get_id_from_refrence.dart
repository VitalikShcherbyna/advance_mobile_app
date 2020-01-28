import 'package:cloud_firestore/cloud_firestore.dart';

String getIdFromReference(DocumentReference reference) =>
    reference?.path != null ? reference.path.split('/')[1] : null;
