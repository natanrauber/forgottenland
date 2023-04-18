import 'package:supabase/supabase.dart';

const String databaseUrl = 'https://ehwqccznlwnxscpzuhuh.supabase.co';
const String databasePublicKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVod3FjY3pubHdueHNjcHp1aHVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzA4Mzk1NTAsImV4cCI6MTk4NjQxNTU1MH0.-6lql0PFwrAqOAbaU9XVx9K2jqrE16vyz-9mHRGUn4E';

class DatabaseClient {
  factory DatabaseClient() => _singleton;
  DatabaseClient._internal();
  static final DatabaseClient _singleton = DatabaseClient._internal();
  SupabaseClient _client = SupabaseClient(databaseUrl, databasePublicKey);

  void start(String supabaseUrl, String supabaseKey) => _client = SupabaseClient(supabaseUrl, supabaseKey);

  SupabaseQueryBuilder from(String table) => _client.from(table);
}
