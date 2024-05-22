import 'package:hive/hive.dart';

part 'history.g.dart';

@HiveType(typeId: 1, adapterName: 'HistoryDataAdapter')
class History extends HiveObject {
  @HiveField(0)
  HiveList gameHistory;

  History(this.gameHistory);
}