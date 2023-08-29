// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:project/database/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static var db , userCollection;
  static connect() async{
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    userCollection = db.collection(USER_COLLECTION);
  }

}