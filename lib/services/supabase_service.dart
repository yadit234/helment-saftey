import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _isInitialized = false;

  // Supabase Storage Bucket Names
  static const String bucketAvatars = 'avatars';
  static const String bucketAssets = 'assets';
  static const String bucketDocuments = 'documents';
  static const String bucketSafetyFiles = 'safety-files';

  static bool get isConfigured => _isInitialized;
  static bool get isStorageAvailable => _isInitialized && client != null;

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    try {
      if (url.isEmpty || anonKey.isEmpty) return;
      await Supabase.initialize(url: url, publishableKey: anonKey);
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Supabase initialization error: $e');
      }
      _isInitialized = false;
    }
  }

  static SupabaseClient? get client {
    if (!_isInitialized) return null;
    return Supabase.instance.client;
  }

  static User? get currentUser => client?.auth.currentUser;

  // Authentication Methods
  static Future<AuthResponse?> signIn(String email, String password) async {
    if (!isConfigured || client == null) return null;
    return await client!.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse?> signUp(String email, String password) async {
    if (!isConfigured || client == null) return null;
    return await client!.auth.signUp(email: email, password: password);
  }

  static Future<void> signOut() async {
    if (!isConfigured || client == null) return;
    await client!.auth.signOut();
  }

  // Supabase Storage API Methods

  /// Uploads binary bytes (Uint8List) to specified bucket and path.
  /// Returns the public URL of the uploaded file on success, or null on failure.
  static Future<String?> uploadBytes({
    required String bucket,
    required String path,
    required Uint8List bytes,
    String? contentType,
    bool upsert = true,
  }) async {
    if (!isStorageAvailable) return null;
    try {
      final storage = client!.storage.from(bucket);
      await storage.uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          contentType: contentType,
          upsert: upsert,
        ),
      );
      return storage.getPublicUrl(path);
    } catch (e) {
      if (kDebugMode) {
        print('Supabase Storage uploadBytes error ($bucket/$path): $e');
      }
      return null;
    }
  }

  /// Uploads raw text/JSON/CSV string data to specified bucket and path.
  /// Returns public URL on success, or null on failure.
  static Future<String?> uploadString({
    required String bucket,
    required String path,
    required String data,
    String contentType = 'text/plain; charset=utf-8',
    bool upsert = true,
  }) async {
    if (!isStorageAvailable) return null;
    try {
      final storage = client!.storage.from(bucket);
      final bytes = Uint8List.fromList(utf8.encode(data));
      await storage.uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          contentType: contentType,
          upsert: upsert,
        ),
      );
      return storage.getPublicUrl(path);
    } catch (e) {
      if (kDebugMode) {
        print('Supabase Storage uploadString error ($bucket/$path): $e');
      }
      return null;
    }
  }

  /// Returns public URL for a file in a storage bucket.
  static String? getPublicUrl(String bucket, String path) {
    if (!isStorageAvailable) return null;
    try {
      return client!.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      if (kDebugMode) {
        print('Supabase Storage getPublicUrl error ($bucket/$path): $e');
      }
      return null;
    }
  }

  /// Downloads file content as Uint8List from specified bucket and path.
  static Future<Uint8List?> downloadBytes(String bucket, String path) async {
    if (!isStorageAvailable) return null;
    try {
      return await client!.storage.from(bucket).download(path);
    } catch (e) {
      if (kDebugMode) {
        print('Supabase Storage downloadBytes error ($bucket/$path): $e');
      }
      return null;
    }
  }

  /// Deletes a file from specified bucket.
  static Future<bool> deleteFile(String bucket, String path) async {
    if (!isStorageAvailable) return false;
    try {
      await client!.storage.from(bucket).remove([path]);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Supabase Storage deleteFile error ($bucket/$path): $e');
      }
      return false;
    }
  }

  /// Lists objects in a directory inside a storage bucket.
  static Future<List<FileObject>> listFiles(
    String bucket, {
    String? path,
  }) async {
    if (!isStorageAvailable) return [];
    try {
      return await client!.storage.from(bucket).list(path: path);
    } catch (e) {
      if (kDebugMode) {
        print('Supabase Storage listFiles error ($bucket/$path): $e');
      }
      return [];
    }
  }
}
