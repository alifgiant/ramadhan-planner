import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:taskist/quran/dialogs/quran_navigator_dialog.dart';
import 'package:taskist/quran/helpers/settings_helpers.dart';
import 'package:taskist/quran/localizations/app_localizations.dart';
import 'package:taskist/quran/models/chapters_models.dart';
import 'package:taskist/quran/models/quran_data_model.dart';
import 'package:taskist/quran/screens/quran_aya_screen.dart';
import 'package:taskist/quran/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
  MainDrawerModel mainDrawerModel;

  @override
  void initState() {
    mainDrawerModel = MainDrawerModel();
    (() async {
      await mainDrawerModel.getChaptersForNavigator();
    })();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ScopedModel<MainDrawerModel>(
                    model: mainDrawerModel,
                    child: ScopedModelDescendant<MainDrawerModel>(
                      builder: (
                        BuildContext context,
                        Widget child,
                        MainDrawerModel model,
                      ) {
                        return ListTile(
                          onTap: () async {
                            var dialog = QuranNavigatorDialog(
                              chapters: model.chapters,
                              currentChapter: model.chapters.keys.first,
                            );
                            var chapter = await showDialog<Chapter>(
                              context: context,
                              builder: (context) {
                                return dialog;
                              },
                            );
                            if (chapter == null) {
                              return;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (
                                  BuildContext context,
                                ) {
                                  return QuranAyaScreen(
                                    chapter: chapter,
                                  );
                                },
                              ),
                            );
                          },
                          title: Text(
                            AppLocalizations.of(context).jumpToVerseText,
                          ),
                          leading: Icon(MdiIcons.arrowRight),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed('/settings');
                    },
                    title: Text(
                      AppLocalizations.of(context).settingsText,
                    ),
                    leading: Icon(Icons.settings),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed('/about');
                    },
                    title: Text(
                      AppLocalizations.of(context).aboutAppText,
                    ),
                    leading: Icon(Icons.info),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainDrawerModel extends Model {
  Map<Chapter, List<Aya>> chapters = {};

  Future getChaptersForNavigator() async {
    var locale = SettingsHelpers.instance.getLocale();
    var chapters = await QuranDataService.instance.getChaptersNavigator(
      locale,
    );
    this.chapters = chapters;
    notifyListeners();
  }
}
