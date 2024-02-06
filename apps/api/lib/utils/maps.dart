import 'package:utils/utils.dart';

Map<String, String> get dateToCategory => <String, String>{
      'experiencegained+today': DT.tibia.today(),
      'experiencegained+yesterday': DT.tibia.yesterday(),
      'experiencegained+last7days': DT.tibia.yesterday(),
      'experiencegained+last30days': DT.tibia.yesterday(),
      'experiencegained+last365days': DT.tibia.yesterday(),
      'onlinetime+today': DT.tibia.today(),
      'onlinetime+yesterday': DT.tibia.yesterday(),
      'onlinetime+last7days': DT.tibia.yesterday(),
      'onlinetime+last30days': DT.tibia.yesterday(),
      'onlinetime+last365days': DT.tibia.yesterday(),
    };

Map<String, String> get tableToCategory => <String, String>{
      'experiencegained+today': 'exp-gain-today',
      'experiencegained+yesterday': 'exp-gain-last-day',
      'experiencegained+last7days': 'exp-gain-last-7-days',
      'experiencegained+last30days': 'exp-gain-last-30-days',
      'experiencegained+last365days': 'exp-gain-last-365-days',
      'onlinetime+today': 'onlinetime',
      'onlinetime+yesterday': 'onlinetime',
      'onlinetime+last7days': 'onlinetime-last7days',
      'onlinetime+last30days': 'onlinetime-last30days',
      'onlinetime+last365days': 'onlinetime-last365days',
    };
