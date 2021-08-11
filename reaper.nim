import ezwin, reaper/[types, functions, extension]

export types, functions, extension

proc testFn() =
  var wnd = newWindow(
    title = "Test Window",
    bounds = ((1.0, 1.0), (4.0, 3.0)),
    parent = pluginInfo.hwnd_main,
  )

createExtension:
  addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testFn)