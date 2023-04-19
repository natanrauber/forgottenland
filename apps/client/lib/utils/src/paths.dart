library paths;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class PATH {
  static const String tibiaDataApi = 'https://api.tibiadata.com/v3';
  static String forgottenLandApi = dotenv.env['API_URL'] ?? '';
}
