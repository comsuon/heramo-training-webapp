enum Role { OD, SHIPPER, QC, CX }

extension RoleExtension on Role {
  int get id {
    switch (this) {
      case Role.OD:
        return 1;
      case Role.CX:
        return 2;
      case Role.SHIPPER:
        return 3;
      case Role.QC:
        return 4;
      default:
        return 0;
    }
  }

  String get name {
    switch (this) {
      case Role.OD:
        return "OD";
      case Role.CX:
        return "CX";
      case Role.SHIPPER:
        return "Shipper";
      case Role.QC:
        return "QC";
      default:
        return "0";
    }
  }
}

const courseListSheetId = "1EPuHKcq_gbeLrUVguphcGxWYsdRSFf50Hx1FBovifGE";
const courseListWorkSheet = "courses";
const resultListWorkSheet = "result";
