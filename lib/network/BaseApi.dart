import 'package:gsheets/gsheets.dart';
import '../utils/constant.dart' as Constants;
class BaseApi {
  final String credential;
  GSheets _gSheets;

  BaseApi(this.credential);

  Spreadsheet spreadsheet;
  Worksheet worksheet;

  Future<void> init() async {
    _gSheets = GSheets(credential);
    spreadsheet ??= await _gSheets.spreadsheet(Constants.courseListSheetId);
  }
}