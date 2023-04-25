import 'package:supabase/supabase.dart';

const String defaultDatabaseUrl = 'https://ehwqccznlwnxscpzuhuh.supabase.co';
const String publicDatabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVod3FjY3pubHdueHNjcHp1aHVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzA4Mzk1NTAsImV4cCI6MTk4NjQxNTU1MH0.-6lql0PFwrAqOAbaU9XVx9K2jqrE16vyz-9mHRGUn4E';

class DatabaseClient {
  factory DatabaseClient() => _singleton;
  DatabaseClient._internal();
  static final DatabaseClient _singleton = DatabaseClient._internal();
  SupabaseClient _client = SupabaseClient(defaultDatabaseUrl, publicDatabaseKey);

  void start(String? databaseUrl, String? databaseKey) {
    if (databaseUrl == null) print('Starting database client with default URL');
    if (databaseUrl == null) print('Starting database client with public key');
    _client = SupabaseClient(databaseUrl ?? defaultDatabaseUrl, databaseKey ?? publicDatabaseKey);
  }

  SupabaseQueryBuilder from(String table) => _client.from(table);
}
