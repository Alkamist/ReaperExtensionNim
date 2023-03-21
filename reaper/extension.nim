import std/tables
import ./types
import ./functions

globalRaiseHook = proc(e: ref Exception): bool {.gcsafe, locks: 0.} =
  ShowMessageBox(
    msg = e.msg & "\n\n" & "Stack Trace:\n\n" & e.getStackTrace(),
    title = "Reaper Extension Error:",
    `type` = 0, # Ok
  )

var actionProcs = initTable[int, proc()]()

var pluginInstance*: HINSTANCE
var plugin*: ptr reaper_plugin_info_t
var getApi*: proc(name: cstring): pointer {.cdecl.}

template addTimerProc*(fn): untyped =
  discard plugin.Register("timer", fn)

template removeTimerProc*(fn): untyped =
  discard plugin.Register("-timer", fn)

proc hookCommand(command: cint, flag: cint): bool =
  if command != 0 and actionProcs.contains(command):
    actionProcs[command]()
    return true

proc addAction*(name, id: cstring, fn: proc()) =
  var commandId = plugin.Register("command_id", cast[pointer](id))
  var accelReg: gaccel_register_t

  accelReg.desc = name
  accelReg.accel.cmd = commandId.uint16

  discard plugin.Register("gaccel", addr accelReg)
  actionProcs[commandId] = fn

template createExtension*(initCode: untyped): untyped =
  proc ReaperPluginEntry(hInst: HINSTANCE, rec: ptr reaper_plugin_info_t): cint {.codegenDecl: "__declspec(dllexport) $# $#$#", exportc, dynlib.} =
    pluginInstance = hInst
    plugin = rec

    if plugin != nil:
      if REAPERAPI_LoadAPI(plugin.GetFunc) != 0:
        return 0

      plugin_getapi = cast[proc(name: cstring): pointer {.cdecl.}](rec.GetFunc("plugin_getapi"))
      discard plugin.Register("hookcommand", hookCommand)

      initCode

      return 1