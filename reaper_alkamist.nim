import reaper

proc testAction() =
  reaper.ShowConsoleMsg("Test Action\n")

proc reaperExtensionMain*(pluginInfo: ptr reaper_plugin_info_t) =
  reaper.ShowConsoleMsg("Hello\n")

  pluginInfo.addAction("Alkamist Test Action", "ALKAMIST_TEST_ACTION", testAction)

reaper.exportExtension()