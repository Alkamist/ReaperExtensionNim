when defined(cpu64):
  type
    INT_PTR* = int64
    UINT_PTR* = uint64
    LONG_PTR* = int64
else:
  type
    INT_PTR* = cint
    UINT_PTR* = cuint
    LONG_PTR* = clong

type
  LPVOID* = pointer
  HANDLE* = LPVOID
  HINSTANCE* = HANDLE
  HMENU* = HANDLE
  HWND* = HANDLE
  HICON* = HANDLE
  HCURSOR* = HANDLE
  HBRUSH* = HANDLE
  HDC* = HANDLE
  HGLRC* = HANDLE
  HMODULE* = HINSTANCE

  BOOL* = cint
  UINT* = cuint
  LONG* = clong
  SHORT* = cshort
  WORD* = cushort
  DWORD* = culong
  BYTE* = uint8
  CHAR* = char

  LPSTR* = cstring
  LPCSTR* = cstring

  LPARAM* = LONG_PTR
  WPARAM* = UINT_PTR
  LRESULT* = LONG_PTR

  POINT* {.bycopy.} = object
    x*: LONG
    y*: LONG

  RECT* {.bycopy.} = object
    left*: LONG
    top*: LONG
    right*: LONG
    bottom*: LONG

  MSG* {.bycopy.} = object
    hwnd*: HWND
    message*: UINT
    wParam*: WPARAM
    lParam*: LPARAM
    time*: DWORD
    pt*: POINT

  ACCEL* {.bycopy.} = object
    fVirt*: uint8
    key*: uint16
    cmd*: uint16

  GUID* {.bycopy.} = object
    Data1*: culong
    Data2*: cushort
    Data3*: cushort
    Data4*: array[8, uint8]

type
  ReaProject* = distinct pointer
  MediaTrack* = distinct pointer
  MediaItem* = distinct pointer
  MediaItem_Take* = distinct pointer
  TrackEnvelope* = distinct pointer
  PCM_source* = distinct pointer
  AudioAccessor* = distinct pointer
  WDL_VirtualWnd_BGCfg* = distinct pointer
  joystick_device* = distinct pointer

  reaper_plugin_info_t* {.bycopy.} = object
    caller_version*: cint
    hwnd_main*: HWND
    Register*: proc(name: cstring; infostruct: pointer): cint {.cdecl.}
    GetFunc*: proc(name: cstring): pointer {.cdecl.}

  MIDI_event_t* {.bycopy.} = object
    frame_offset*: cint
    size*: cint
    midi_message*: array[4, uint8]

  MIDI_eventprops* {.bycopy.} = object
    ppqpos*: cdouble
    ppqpos_end_or_bezier_tension*: cdouble
    flag*: char
    msg*: array[3, uint8]
    varmsg*: cstring
    varmsglen*: cint
    setflag*: cint

  REAPER_cue* {.bycopy.} = object
    m_id*: cint
    m_time*: cdouble
    m_endtime*: cdouble
    m_isregion*: bool
    m_name*: cstring
    m_flags*: cint
    resvd*: array[124, char]

  REAPER_inline_positioninfo* {.bycopy.} = object
    draw_start_time*: cdouble
    draw_start_y*: cint
    pixels_per_second*: cdouble
    width*: cint
    height*: cint
    mouse_x*: cint
    mouse_y*: cint
    extraParms*: array[8, pointer]

  midi_quantize_mode_t* {.bycopy.} = object
    doquant*: bool
    movemode*: char
    sizemode*: char
    quantstrength*: char
    quantamt*: cdouble
    swingamt*: char
    range_min*: char
    range_max*: char

  accelerator_register_t* {.bycopy.} = object
    translateAccel*: proc(msg: ptr MSG, ctx: ptr accelerator_register_t): cint {.cdecl.}
    isLocal*: bool
    user*: pointer

  custom_action_register_t* {.bycopy.} = object
    uniqueSectionId*: cint
    idStr*: cstring
    name*: cstring
    extra*: pointer

  gaccel_register_t* {.bycopy.} = object
    accel*: ACCEL
    desc*: cstring

  action_help_t* {.bycopy.} = object
    action_desc*: cstring
    action_help*: cstring

  editor_register_t* {.bycopy.} = object
    editFile*: proc(filename: cstring; parent: HWND; trackidx: cint): cint {.cdecl.}
    wouldHandle*: proc(filename: cstring): cstring {.cdecl.}

  prefs_page_register_t* {.bycopy.} = object
    idstr*: cstring
    displayname*: cstring
    create*: proc(par: HWND): HWND {.cdecl.}
    par_id*: cint
    par_idstr*: cstring
    childrenFlag*: cint
    treeitem*: pointer
    hwndCache*: HWND
    extra*: array[64, char]

  KbdCmd* {.bycopy.} = object
    cmd*: DWORD
    text*: cstring

  KbdKeyBindingInfo* {.bycopy.} = object
    key*: cint
    cmd*: cint
    flags*: cint

  KbdSectionInfo* {.bycopy.} = object
    uniqueID*: cint
    name*: cstring
    action_list*: ptr KbdCmd
    action_list_cnt*: cint
    def_keys*: ptr KbdKeyBindingInfo
    def_keys_cnt*: cint
    onAction*: proc(cmd: cint; val: cint; valhw: cint; relmode: cint; hwnd: HWND): bool {.cdecl.}
    accels*: pointer
    recent_cmds*: pointer
    extended_data*: array[32, pointer]