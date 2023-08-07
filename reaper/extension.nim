import std/tables
import ./types
import ./api

var actionTable: Table[cint, proc()]

proc addAction*(pluginInfo: ptr reaper_plugin_info_t, name, id: string, action: proc()) =
  var id = cstring(id)

  let commandId = pluginInfo.Register("command_id", addr(id[0]))

  var accelRegister: gaccel_register_t
  accelRegister.desc = name
  accelRegister.accel.cmd = uint16(commandId)

  discard pluginInfo.Register("gaccel", addr(accelRegister))
  actionTable[commandId] = action

proc hookCommand(command, flag: cint): bool {.cdecl.} =
  if command == 0:
    return false

  if actionTable.hasKey(command):
    actionTable[command]()
    return true

  return false

template exportExtension*() =
  {.emit: "/*TYPESECTION*/N_LIB_EXPORT N_CDECL(void, NimMain)(void);".}

  proc ReaperPluginEntry(hInst: HINSTANCE, rec: ptr reaper_plugin_info_t): cint {.exportc, dynlib.} =
    if rec != nil:
      {.emit: "NimMain();".}
      loadApi(rec)
      discard rec.Register("hookcommand", hookCommand)
      reaperExtensionMain(rec)
      return 1