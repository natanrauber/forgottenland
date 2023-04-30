import 'package:database_client/default_database_access_data.dart';
import 'package:database_client/src/database_client_interface.dart';
import 'package:supabase/supabase.dart';

class MySupabaseClient implements IDatabaseClient {
  MySupabaseClient({
    String databaseUrl = defaultDatabaseUrl,
    String databaseKey = defaultDatabasePKey,
  }) : _client = SupabaseClient(databaseUrl, databaseKey);

  SupabaseClient _client;

  @override
  void setup(String? databaseUrl, String? databaseKey) {
    if (databaseUrl == null) print('Starting database client with default URL');
    if (databaseUrl == null) print('Starting database client with public key');
    _client = SupabaseClient(databaseUrl ?? defaultDatabaseUrl, databaseKey ?? defaultDatabasePKey);
  }

  @override
  SupabaseQueryBuilder from(String table) => _client.from(table);
}
