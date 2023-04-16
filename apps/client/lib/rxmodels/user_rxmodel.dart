import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:models/models.dart';

class RxUser extends Rx<User> {
  RxUser(super.initial);
}

extension UserExtension on User {
  /// Returns a `RxUser` with [this] `User` as initial value.
  RxUser get obs => RxUser(this);
}
