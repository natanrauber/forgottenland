import 'package:cron_scheduler/cron_scheduler.dart';
import 'package:http_client/http_client.dart';
import 'package:utils/utils.dart';

final IHttpClient _httpClient = MyDioClient(
  baseOptions: MyDioClient.defaultBaseOptions.copyWith(
    sendTimeout: Duration(minutes: 5),
    receiveTimeout: Duration(minutes: 5),
    connectTimeout: Duration(minutes: 5),
  ),
);
final Env _env = Env();

void main(List<String> arguments) {
  _env;
  _env;
  List cronList = <CronJob>[
    CronJob(time: '*/5 * * * *', name: 'online', task: () => _etlGet('/online')),
    CronJob(time: '50 * * * *', name: 'exp-record', task: () => _etlGet('/exprecord')),
    CronJob(time: '50 * * * *', name: 'current-exp', task: () => _etlGet('/currentexp')),
    CronJob(time: '55 * * * *', name: 'expgain+today', task: () => _etlGet('/expgain+today')),
    CronJob(time: '55 * * * *', name: 'expgain+yesterday', task: () => _etlGet('/expgain+yesterday')),
    CronJob(time: '55 * * * *', name: 'expgain+last7days', task: () => _etlGet('/expgain+last7days')),
    CronJob(time: '55 * * * *', name: 'expgain+last30days', task: () => _etlGet('/expgain+last30days')),
    CronJob(time: '0 0 * * 0', name: 'rookmaster', task: () => _etlGet('/rookmaster')),
  ];

  print('Scheduling cron jobs:');
  for (int i = 0; i < cronList.length; i++) {
    CronJob e = cronList[i];
    print('\t[${i + 1}/${cronList.length}] (${e.time}) ${e.name}');
    e.start();
  }
}

Future<void> _etlGet(String path) => _httpClient.get(
      '${_env['PATH_ETL']}$path',
      headers: {
        'supabaseUrl': _env['DATABASE_URL'],
        'supabaseKey': _env['DATABASE_KEY'],
      },
    );
