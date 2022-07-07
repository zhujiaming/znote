import 'package:znote/comm/flustars/date_util.dart';

class TimeFormatter{
  static String getHomeListFormatter(int milliseconds) {
    String showTime;
    if (DateUtil.getNowDateMs() - milliseconds < 60000) {
      showTime = "刚刚";
    } else if (DateUtil.isToday(milliseconds)) {
      showTime = DateUtil.formatDateMs(milliseconds, format: "HH:mm");
    } else if (DateUtil.isYesterdayByMs(
        milliseconds, DateUtil.getNowDateMs())) {
      showTime = '昨天${DateUtil.formatDateMs(milliseconds, format: "HH:mm")}';
    } else if ((DateUtil.getDayOfYearByMs(milliseconds) -
        DateUtil.getDayOfYear(DateTime.now())) ==
        2) {
      showTime = '前天${DateUtil.formatDateMs(milliseconds, format: "HH:mm")}';
    } else if (DateUtil.yearIsEqualByMs(
        milliseconds, DateUtil.getNowDateMs())) {
      showTime = DateUtil.formatDateMs(milliseconds, format: 'M月d日');
    } else {
      showTime = DateUtil.formatDateMs(milliseconds, format: 'yyyy年M月d日');
    }
    return showTime;
  }
}