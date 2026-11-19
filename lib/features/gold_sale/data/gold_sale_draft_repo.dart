import 'dart:convert';

import 'package:gold_shop_app/features/gold_sale/data/gold_sale_draft.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoldSaleDraftRepo {
  GoldSaleDraftRepo({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _draftKey = 'gold_sale_draft_v1';

  final SharedPreferencesAsync _preferences;

  Future<void> save(GoldSaleDraft draft) async {
    final json = jsonEncode(draft.toJson());
    await _preferences.setString(_draftKey, json);
  }

  Future<GoldSaleDraft?> load() async {
    final json = await _preferences.getString(_draftKey);
    if (json == null) return null;

    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return GoldSaleDraft.fromJson(decoded);
  }

  Future<void> clear() async {
    await _preferences.remove(_draftKey);
  }
}
