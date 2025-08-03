import 'package:flutter/widgets.dart';

/// Fl_Chart up through 0.60.0 still calls
///   MediaQuery.boldTextOverride(context)
/// which was removed in Flutter 3.7+.  We restore it here as a no-op.
extension MediaQueryPatch on MediaQuery {
  static bool get boldTextOverride => false;
}
