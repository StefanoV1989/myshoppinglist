
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshoppinglist/models/category.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Category>> getCategories(String userID, {String selectedCategoryID = ""}) async {

    List<Category> categories = [];

    CollectionReference<Map<String, dynamic>> categoriesRef = _firestore.collection('categories');
    Query<Map<String, dynamic>> query = categoriesRef.where('userID', isEqualTo: userID);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    for(QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs)
    {
      Map<String, dynamic> documentData = document.data();
      bool isSelectedCat = selectedCategoryID == document.id ? true : false;
      categories.add(
        Category(name: documentData['name'], categoryID: document.id, userID: documentData['userID'], isSelected: isSelectedCat)
      );
    }

    return categories;
  }

  Future<void> addCategory(Category cat) async {
    CollectionReference<Map<String, dynamic>> categoriesRef = _firestore.collection('categories');

    await categoriesRef.add({
      'name': cat.name,
      'userID': cat.userID
    });
  }

  Future<void> delCategory(String categoryID) async {
    CollectionReference<Map<String, dynamic>> categoriesRef = _firestore.collection('categories');

    await categoriesRef.doc(categoryID).delete();
  }
}
