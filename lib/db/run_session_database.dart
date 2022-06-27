import 'dart:async';
import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:flutter_myfitexercisecompanion/db/run_session_dao.dart';
import 'package:flutter_myfitexercisecompanion/models/run_session.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'run_session_database.g.dart';

@Database(version: 1, entities: [RunSession])
abstract class RunSessionDatabase extends FloorDatabase{
  RunSessionDao get runSessionDao;
}