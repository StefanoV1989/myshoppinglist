import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshoppinglist/models/myitem.dart';

class ItemRepository {
  final FirebaseFirestore _firestore;

  ItemRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<MyItem>> getItems(String categoryID) async {
    List<MyItem> items = [];

    CollectionReference<Map<String, dynamic>> itemsRef = _firestore.collection("categories/$categoryID/items");
    Query<Map<String, dynamic>> query = itemsRef.orderBy("isCompleted", descending: false);
    QuerySnapshot<Map<String, dynamic>> itemSnapshot = await query.get();
    
    for (QueryDocumentSnapshot<Map<String, dynamic>> document in itemSnapshot.docs) {
      Map<String, dynamic> documentData = document.data();
      items.add(MyItem(
        name: documentData['name'],
        note: documentData['note'],
        categoryID: categoryID,
        isCompleted: documentData['isCompleted'],
        id: document.id,
      ));
    }

    return items;
  }

  Future<void> addItem(MyItem item) async {
    CollectionReference<Map<String, dynamic>> itemsRef = _firestore.collection("categories/${item.categoryID}/items");

    await itemsRef.add({
      'name': item.name,
      'note': item.note,
      'isCompleted': item.isCompleted,
    });
  }

  Future<void> updateItem(MyItem item) async {
    DocumentReference<Map<String, dynamic>> itemsRef = _firestore.doc("categories/${item.categoryID}/items/${item.id}");

    await itemsRef.set({
      'name': item.name,
      'note': item.note,
      'isCompleted': item.isCompleted,
    });
  }

  Future<void> delItem(MyItem item) async {
    CollectionReference<Map<String, dynamic>> itemsRef = _firestore.collection("categories/${item.categoryID}/items");
    
    await itemsRef.doc(item.id).delete();
  }
}
