import 'package:supabase/supabase.dart';
import 'package:utils/utils.dart';

const String supabasePublicKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVod3FjY3pubHdueHNjcHp1aHVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzA4Mzk1NTAsImV4cCI6MTk4NjQxNTU1MH0.-6lql0PFwrAqOAbaU9XVx9K2jqrE16vyz-9mHRGUn4E';

class MySupabaseClient {
  factory MySupabaseClient() => _singleton;
  MySupabaseClient._internal();
  static final MySupabaseClient _singleton = MySupabaseClient._internal();

  SupabaseClient client = SupabaseClient(PATH.supabase, supabasePublicKey);

  void start(String supabaseUrl, String supabaseKey) => client = SupabaseClient(supabaseUrl, supabaseKey);
}
