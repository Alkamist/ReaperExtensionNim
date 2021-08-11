import winim/lean

export lean

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

  # LICE_IBitmap* = distinct pointer
  # LICE_IFont* = distinct pointer
  # LICE_pixel* = cuint
  # LICE_pixel_chan* = cuchar

  reaper_plugin_info_t* = object
    caller_version*: cint
    hwnd_main*: HWND
    Register*: proc(name: cstring; infostruct: pointer): cint {.cdecl.}
    GetFunc*: proc(name: cstring): pointer {.cdecl.}

  MIDI_event_t* = object
    frame_offset*: cint
    size*: cint
    midi_message*: array[4, cuchar]

  MIDI_eventprops* = object
    ppqpos*: cdouble
    ppqpos_end_or_bezier_tension*: cdouble
    flag*: char
    msg*: array[3, cuchar]
    varmsg*: cstring
    varmsglen*: cint
    setflag*: cint

  REAPER_cue* = object
    m_id*: cint
    m_time*: cdouble
    m_endtime*: cdouble
    m_isregion*: bool
    m_name*: cstring
    m_flags*: cint
    resvd*: array[124, char]

  REAPER_inline_positioninfo* = object
    draw_start_time*: cdouble
    draw_start_y*: cint
    pixels_per_second*: cdouble
    width*: cint
    height*: cint
    mouse_x*: cint
    mouse_y*: cint
    extraParms*: array[8, pointer]

  midi_quantize_mode_t* = object
    doquant*: bool
    movemode*: char
    sizemode*: char
    quantstrength*: char
    quantamt*: cdouble
    swingamt*: char
    range_min*: char
    range_max*: char

  accelerator_register_t* = object
    translateAccel*: proc(msg: ptr MSG, ctx: ptr accelerator_register_t): cint {.cdecl.}
    isLocal*: bool
    user*: pointer

  custom_action_register_t* = object
    uniqueSectionId*: cint
    idStr*: cstring
    name*: cstring
    extra*: pointer

  gaccel_register_t* = object
    accel*: ACCEL
    desc*: cstring

  action_help_t* = object
    action_desc*: cstring
    action_help*: cstring

  editor_register_t* = object
    editFile*: proc(filename: cstring; parent: HWND; trackidx: cint): cint {.cdecl.}
    wouldHandle*: proc(filename: cstring): cstring {.cdecl.}

  prefs_page_register_t* = object
    idstr*: cstring
    displayname*: cstring
    create*: proc(par: HWND): HWND {.cdecl.}
    par_id*: cint
    par_idstr*: cstring
    childrenFlag*: cint
    treeitem*: pointer
    hwndCache*: HWND
    extra*: array[64, char]

  KbdCmd* = object
    cmd*: DWORD
    text*: cstring

  KbdKeyBindingInfo* = object
    key*: cint
    cmd*: cint
    flags*: cint

  KbdSectionInfo* = object
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