import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Stream<List<T>> getDataStream<T>({
  required String table,
  required List<String> ids,
  required T Function(Map<String, dynamic> json) fromJson
}){
  var stream = supabase.from("table").stream(primaryKey: ids); //["id"] : la mot ListString, neu ghi "id" -> bi xung dot
  return stream.map((mapList) =>
      mapList.map(
            (map) => fromJson(map), // Fruit.fromJson(map) la ham khoi tao thuoc lop fruir, khoi tao 1 the hienj cuar fruit
      ).toList());
}

Future<String> uploadImage(
    {
      required File image,
      required String bucket,
      required String path,
      bool upsert = false})
async {
  await supabase.storage.from(bucket).upload(path, image,
      fileOptions: FileOptions(cacheControl: '3600', upsert: upsert));

  final String publicUrl = supabase.storage.from(bucket).getPublicUrl(path);

  return publicUrl;
}


Future<String> uploadImageBin(
    {
      required Uint8List image,
      required String bucket,
      required String path,
      bool upsert = false})
async {
  await supabase.storage.from(bucket).updateBinary(path, image,
      fileOptions: FileOptions(cacheControl: '3600', upsert: upsert));

  final String publicUrl = supabase.storage.from(bucket).getPublicUrl(path);

  return publicUrl;
}

Future<String> updateImage(
    {
      required File image,
      required String bucket,
      required String path,
      bool upsert = false})
async {
  await supabase.storage.from(bucket).update(path, image,
      fileOptions: FileOptions(cacheControl: '3600', upsert: upsert));

  final String publicUrl = supabase.storage.from(bucket).getPublicUrl(path);

  return publicUrl +"?ts=${DateTime.now().millisecond}";
}