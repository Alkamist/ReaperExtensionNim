import reaper/[types, functions, extension]

export types, functions, extension

proc WndProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
  case msg:
  of WM_SYSCOMMAND:
      if (wParam and 0xfff0) == SC_KEYMENU:
        return 0

  of WM_DESTROY:
    PostQuitMessage(0)

  else:
    discard

  DefWindowProc(hWnd, msg, wParam, lParam)

proc testFn() =
  var wc = WNDCLASSEX(
    cbSize: WNDCLASSEX.sizeof.UINT,
    style: CS_CLASSDC,
    lpfnWndProc: WndProc,
    cbClsExtra: 0,
    cbWndExtra: 0,
    hInstance: GetModuleHandle(nil),
    hIcon: 0,
    hCursor: 0,
    hbrBackground: 0,
    lpszMenuName: nil,
    lpszClassName: "Test Class",
    hIconSm: 0,
  )

  RegisterClassEx(wc)

  let hWnd = CreateWindow(
    lpClassName = wc.lpszClassName,
    lpWindowName = "Test Window",
    dwStyle = WS_OVERLAPPEDWINDOW,
    x = 100,
    y = 100,
    nWidth = 1280,
    nHeight = 800,
    hWndParent = pluginInfo.hwnd_main,
    hMenu = 0,
    hInstance = wc.hInstance,
    lpParam = nil,
  )

  ShowWindow(hwnd, SW_SHOWDEFAULT)
  UpdateWindow(hwnd)

  # var
  #   windowShouldClose = false
  #   msg: MSG

  # while not windowShouldClose:
  #   while PeekMessage(msg, 0, 0, 0, PM_REMOVE):
  #     TranslateMessage(msg)
  #     DispatchMessage(msg)
  #     if msg.message == WM_QUIT:
  #       windowShouldClose = true

createExtension:
  addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testFn)