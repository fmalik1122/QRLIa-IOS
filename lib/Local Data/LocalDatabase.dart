import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import '../DataModers/FrieList.dart';

class LocalDatabase {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE friendsCircle(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        connectionid INTEGER,
        frienduserid INTEGER,
        friendusername TEXT,
        friendname TEXT,
        friendimage TEXT,
        requestid TEXT,
        requeststatus TEXT,
        requestdatetime TEXT,
        friendemail TEXT,
        friendphone TEXT,
        meetingcomment TEXT,
        meetingselfie TEXT,
        meetingaddress TEXT,
        meetinglongitude TEXT,
        meetinglatitude TEXT,
        friendaccttype TEXT,
        businessaddress TEXT,
        businesslongitude TEXT,
        businesslatitude TEXT,
        blockstatus INTEGER,
        blockedby INTEGER,
        businesstype TEXT,
        workbusinessname TEXT,
        worktitle TEXT,
        workemail TEXT,
        website TEXT,
        about TEXT,
        friendbusinesstype TEXT,
        meetingdatetime TEXT,
        webprofileshow INTEGER,
        IsVirtualBusiness INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'friendsCircle.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String title, String descrption) async {
    final db = await LocalDatabase.db();
    final data = {'title': title, 'description': descrption};
    final id = await db.insert('friendsCircle', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<void> createBulkItems(List<Friendslist> friendslist) async {
    final db = await LocalDatabase.db();
    Batch batch = db.batch();
    friendslist.forEach((val) {
      batch.insert('friendsCircle', val.toJson(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await LocalDatabase.db();
    return db.query('friendsCircle', orderBy: "id");
  }

  static Future<void> deleteAllItem() async {
    final db = await LocalDatabase.db();
    await db.delete('friendsCircle', where: null, whereArgs: null);
  }
}