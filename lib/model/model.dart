import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const tableRooms = SqfEntityTable(
    tableName: "rooms",
    primaryKeyName: "roomId",
    modelName: null,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField("name", DbType.text, isNotNull: true),
      SqfEntityField("iconPath", DbType.text),
      SqfEntityField("headerImagePath", DbType.text)
    ]);

const tableBundles = SqfEntityTable(
    tableName: "bundles",
    primaryKeyName: "bundleId",
    modelName: null,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField("name", DbType.text, isNotNull: true),
      SqfEntityField("iconPath", DbType.text),
      SqfEntityField("headerImagePath", DbType.text),
      SqfEntityFieldRelationship(
          parentTable: tableRooms, fieldName: "bundleRoom")
    ]);

const tableItems = SqfEntityTable(
    tableName: "items",
    primaryKeyName: "itemId",
    modelName: null,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField("name", DbType.text, isNotNull: true),
      SqfEntityField("complete", DbType.bool),
      SqfEntityFieldRelationship(
          parentTable: tableRooms, fieldName: "itemBundle")
    ]);

@SqfEntityBuilder(databaseModel)
const databaseModel = SqfEntityModel(
  modelName: "databaseModel",
  databaseName: "stardew-tracker-database.db",
  password: null,
  databaseTables: [tableRooms, tableBundles, tableItems],
  bundledDatabasePath: null,
);
