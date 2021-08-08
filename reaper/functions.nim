import std/macros, types

macro defineLoadApi(procs: untyped): untyped =
  let getApiIdent = ident "getAPI"
  var
    varSection = nnkVarSection.newTree()
    codeSection = nnkStmtList.newTree()

  for p in procs:
    var
      pPragma = nnkPragma.newTree()
      cName = p.name.toStrLit

    for prag in p[4]:
      if prag.kind == nnkExprColonExpr and
         prag[0] == ident "importc":
        cName = prag[1]
        continue
      pPragma.add prag

    var pTyp = nnkProcTy.newTree(
      p[3],
      pPragma,
    )
    varSection.add newIdentDefs(
      p[0],
      pTyp,
    )
    codeSection.add nnkAsgn.newTree(
      p.name,
      nnkCast.newTree(
        pTyp,
        nnkCall.newTree(
          getApiIdent,
          cName,
        ),
      ),
    )
    codeSection.add nnkIfStmt.newTree(
      nnkElifBranch.newTree(
        nnkInfix.newTree(ident "==", p.name, newNilLit()),
        nnkReturnStmt.newTree(newIntLitNode(1)),
      ),
    )

  quote do:
    `varSection`
    proc REAPERAPI_LoadAPI*(`getApiIdent`: proc(name: cstring): pointer {.cdecl.}): cint =
      `codeSection`

defineLoadApi:
  proc AddCustomizableMenu*(menuidstr: cstring; menuname: cstring; kbdsecname: cstring; addtomainmenu: bool): bool {.cdecl.}
  proc AddExtensionsMainMenu*(): bool {.cdecl.}
  proc AddMediaItemToTrack*(tr: MediaTrack): MediaItem {.cdecl.}
  proc AddProjectMarker*(proj: ReaProject; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; wantidx: cint): cint {.cdecl.}
  proc AddProjectMarker2*(proj: ReaProject; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; wantidx: cint; color: cint): cint {.cdecl.}
  proc AddRemoveReaScript*(add: bool; sectionID: cint; scriptfn: cstring; commit: bool): cint {.cdecl.}
  proc AddTakeToMediaItem*(item: MediaItem): MediaItem_Take {.cdecl.}
  proc AddTempoTimeSigMarker*(proj: ReaProject; timepos: cdouble; bpm: cdouble; timesig_num: cint; timesig_denom: cint; lineartempochange: bool): bool {.cdecl.}
  proc adjustZoom*(amt: cdouble; forceset: cint; doupd: bool; centermode: cint) {.cdecl.}
  proc AnyTrackSolo*(proj: ReaProject): bool {.cdecl.}
  proc APIExists*(function_name: cstring): bool {.cdecl.}
  proc APITest*() {.cdecl.}
  proc ApplyNudge*(project: ReaProject; nudgeflag: cint; nudgewhat: cint; nudgeunits: cint; value: cdouble; reverse: bool; copies: cint): bool {.cdecl.}
  proc ArmCommand*(cmd: cint; sectionname: cstring) {.cdecl.}
  proc Audio_Init*() {.cdecl.}
  proc Audio_IsPreBuffer*(): cint {.cdecl.}
  proc Audio_IsRunning*(): cint {.cdecl.}
  proc Audio_Quit*() {.cdecl.}
  # proc Audio_RegHardwareHook*(isAdd: bool; reg: ptr audio_hook_register_t): cint {.cdecl.}
  # proc AudioAccessorStateChanged*(accessor: ptr AudioAccessor): bool {.cdecl.}
  # proc AudioAccessorUpdate*(accessor: ptr AudioAccessor) {.cdecl.}
  # proc AudioAccessorValidateState*(accessor: ptr AudioAccessor): bool {.cdecl.}
  proc BypassFxAllTracks*(bypass: cint) {.cdecl.}
  # proc CalculatePeaks*(srcBlock: ptr PCM_source_transfer_t; pksBlock: ptr PCM_source_peaktransfer_t): cint {.cdecl.}
  # proc CalculatePeaksFloatSrcPtr*(srcBlock: ptr PCM_source_transfer_t; pksBlock: ptr PCM_source_peaktransfer_t): cint {.cdecl.}
  proc ClearAllRecArmed*() {.cdecl.}
  proc ClearConsole*() {.cdecl.}
  proc ClearPeakCache*() {.cdecl.}
  proc ColorFromNative*(col: cint; rOut: ptr cint; gOut: ptr cint; bOut: ptr cint) {.cdecl.}
  proc ColorToNative*(r: cint; g: cint; b: cint): cint {.cdecl.}
  proc CountActionShortcuts*(section: ptr KbdSectionInfo; cmdID: cint): cint {.cdecl.}
  proc CountAutomationItems*(env: TrackEnvelope): cint {.cdecl.}
  proc CountEnvelopePoints*(envelope: TrackEnvelope): cint {.cdecl.}
  proc CountEnvelopePointsEx*(envelope: TrackEnvelope; autoitem_idx: cint): cint {.cdecl.}
  proc CountMediaItems*(proj: ReaProject): cint {.cdecl.}
  proc CountProjectMarkers*(proj: ReaProject; num_markersOut: ptr cint; num_regionsOut: ptr cint): cint {.cdecl.}
  proc CountSelectedMediaItems*(proj: ReaProject): cint {.cdecl.}
  proc CountSelectedTracks*(proj: ReaProject): cint {.cdecl.}
  proc CountSelectedTracks2*(proj: ReaProject; wantmaster: bool): cint {.cdecl.}
  proc CountTakeEnvelopes*(take: MediaItem_Take): cint {.cdecl.}
  proc CountTakes*(item: MediaItem): cint {.cdecl.}
  proc CountTCPFXParms*(project: ReaProject; track: MediaTrack): cint {.cdecl.}
  proc CountTempoTimeSigMarkers*(proj: ReaProject): cint {.cdecl.}
  proc CountTrackEnvelopes*(track: MediaTrack): cint {.cdecl.}
  proc CountTrackMediaItems*(track: MediaTrack): cint {.cdecl.}
  proc CountTracks*(projOptional: ReaProject): cint {.cdecl.}
  proc CreateLocalOscHandler*(obj: pointer; callback: pointer): pointer {.cdecl.}
  # proc CreateMIDIInput*(dev: cint): ptr midi_Input {.cdecl.}
  # proc CreateMIDIOutput*(dev: cint; streamMode: bool; msoffset100: ptr cint): ptr midi_Output {.cdecl.}
  proc CreateNewMIDIItemInProj*(track: MediaTrack; starttime: cdouble; endtime: cdouble; qnInOptional: ptr bool): MediaItem {.cdecl.}
  proc CreateTakeAudioAccessor*(take: MediaItem_Take): ptr AudioAccessor {.cdecl.}
  proc CreateTrackAudioAccessor*(track: MediaTrack): ptr AudioAccessor {.cdecl.}
  proc CreateTrackSend*(tr: MediaTrack; desttrInOptional: MediaTrack): cint {.cdecl.}
  proc CSurf_FlushUndo*(force: bool) {.cdecl.}
  proc CSurf_GetTouchState*(trackid: MediaTrack; isPan: cint): bool {.cdecl.}
  proc CSurf_GoEnd*() {.cdecl.}
  proc CSurf_GoStart*() {.cdecl.}
  proc CSurf_NumTracks*(mcpView: bool): cint {.cdecl.}
  proc CSurf_OnArrow*(whichdir: cint; wantzoom: bool) {.cdecl.}
  proc CSurf_OnFwd*(seekplay: cint) {.cdecl.}
  proc CSurf_OnFXChange*(trackid: MediaTrack; en: cint): bool {.cdecl.}
  proc CSurf_OnInputMonitorChange*(trackid: MediaTrack; monitor: cint): cint {.cdecl.}
  proc CSurf_OnInputMonitorChangeEx*(trackid: MediaTrack; monitor: cint; allowgang: bool): cint {.cdecl.}
  proc CSurf_OnMuteChange*(trackid: MediaTrack; mute: cint): bool {.cdecl.}
  proc CSurf_OnMuteChangeEx*(trackid: MediaTrack; mute: cint; allowgang: bool): bool {.cdecl.}
  proc CSurf_OnOscControlMessage*(msg: cstring; arg: ptr cfloat) {.cdecl.}
  proc CSurf_OnPanChange*(trackid: MediaTrack; pan: cdouble; relative: bool): cdouble {.cdecl.}
  proc CSurf_OnPanChangeEx*(trackid: MediaTrack; pan: cdouble; relative: bool; allowGang: bool): cdouble {.cdecl.}
  proc CSurf_OnPause*() {.cdecl.}
  proc CSurf_OnPlay*() {.cdecl.}
  proc CSurf_OnPlayRateChange*(playrate: cdouble) {.cdecl.}
  proc CSurf_OnRecArmChange*(trackid: MediaTrack; recarm: cint): bool {.cdecl.}
  proc CSurf_OnRecArmChangeEx*(trackid: MediaTrack; recarm: cint; allowgang: bool): bool {.cdecl.}
  proc CSurf_OnRecord*() {.cdecl.}
  proc CSurf_OnRecvPanChange*(trackid: MediaTrack; recv_index: cint; pan: cdouble; relative: bool): cdouble {.cdecl.}
  proc CSurf_OnRecvVolumeChange*(trackid: MediaTrack; recv_index: cint; volume: cdouble; relative: bool): cdouble {.cdecl.}
  proc CSurf_OnRew*(seekplay: cint) {.cdecl.}
  proc CSurf_OnRewFwd*(seekplay: cint; dir: cint) {.cdecl.}
  proc CSurf_OnScroll*(xdir: cint; ydir: cint) {.cdecl.}
  proc CSurf_OnSelectedChange*(trackid: MediaTrack; selected: cint): bool {.cdecl.}
  proc CSurf_OnSendPanChange*(trackid: MediaTrack; send_index: cint; pan: cdouble; relative: bool): cdouble {.cdecl.}
  proc CSurf_OnSendVolumeChange*(trackid: MediaTrack; send_index: cint; volume: cdouble; relative: bool): cdouble {.cdecl.}
  proc CSurf_OnSoloChange*(trackid: MediaTrack; solo: cint): bool {.cdecl.}
  proc CSurf_OnSoloChangeEx*(trackid: MediaTrack; solo: cint; allowgang: bool): bool {.cdecl.}
  proc CSurf_OnStop*() {.cdecl.}
  proc CSurf_OnTempoChange*(bpm: cdouble) {.cdecl.}
  proc CSurf_OnTrackSelection*(trackid: MediaTrack) {.cdecl.}
  proc CSurf_OnVolumeChange*(trackid: MediaTrack; volume: cdouble; relative: bool): cdouble {.cdecl.}
  proc CSurf_OnVolumeChangeEx*(trackid: MediaTrack; volume: cdouble; relative: bool; allowGang: bool): cdouble {.cdecl.}
  proc CSurf_OnWidthChange*(trackid: MediaTrack; width: cdouble; relative: bool): cdouble {.cdecl.}
  proc CSurf_OnWidthChangeEx*(trackid: MediaTrack; width: cdouble; relative: bool; allowGang: bool): cdouble {.cdecl.}
  proc CSurf_OnZoom*(xdir: cint; ydir: cint) {.cdecl.}
  proc CSurf_ResetAllCachedVolPanStates*() {.cdecl.}
  proc CSurf_ScrubAmt*(amt: cdouble) {.cdecl.}
  # proc CSurf_SetAutoMode*(mode: cint; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  # proc CSurf_SetPlayState*(play: bool; pause: bool; rec: bool; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  # proc CSurf_SetRepeatState*(rep: bool; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  # proc CSurf_SetSurfaceMute*(trackid: MediaTrack; mute: bool; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  # proc CSurf_SetSurfacePan*(trackid: MediaTrack; pan: cdouble; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  # proc CSurf_SetSurfaceRecArm*(trackid: MediaTrack; recarm: bool; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  # proc CSurf_SetSurfaceSelected*(trackid: MediaTrack; selected: bool; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  # proc CSurf_SetSurfaceSolo*(trackid: MediaTrack; solo: bool; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  # proc CSurf_SetSurfaceVolume*(trackid: MediaTrack; volume: cdouble; ignoresurf: ptr IReaperControlSurface) {.cdecl.}
  proc CSurf_SetTrackListChange*() {.cdecl.}
  proc CSurf_TrackFromID*(idx: cint; mcpView: bool): MediaTrack {.cdecl.}
  proc CSurf_TrackToID*(track: MediaTrack; mcpView: bool): cint {.cdecl.}
  proc DB2SLIDER*(x: cdouble): cdouble {.cdecl.}
  proc DeleteActionShortcut*(section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint): bool {.cdecl.}
  proc DeleteEnvelopePointEx*(envelope: TrackEnvelope; autoitem_idx: cint; ptidx: cint): bool {.cdecl.}
  proc DeleteEnvelopePointRange*(envelope: TrackEnvelope; time_start: cdouble; time_end: cdouble): bool {.cdecl.}
  proc DeleteEnvelopePointRangeEx*(envelope: TrackEnvelope; autoitem_idx: cint; time_start: cdouble; time_end: cdouble): bool {.cdecl.}
  proc DeleteExtState*(section: cstring; key: cstring; persist: bool) {.cdecl.}
  proc DeleteProjectMarker*(proj: ReaProject; markrgnindexnumber: cint; isrgn: bool): bool {.cdecl.}
  proc DeleteProjectMarkerByIndex*(proj: ReaProject; markrgnidx: cint): bool {.cdecl.}
  proc DeleteTakeMarker*(take: MediaItem_Take; idx: cint): bool {.cdecl.}
  proc DeleteTakeStretchMarkers*(take: MediaItem_Take; idx: cint; countInOptional: ptr cint): cint {.cdecl.}
  proc DeleteTempoTimeSigMarker*(project: ReaProject; markerindex: cint): bool {.cdecl.}
  proc DeleteTrack*(tr: MediaTrack) {.cdecl.}
  proc DeleteTrackMediaItem*(tr: MediaTrack; it: MediaItem): bool {.cdecl.}
  proc DestroyAudioAccessor*(accessor: ptr AudioAccessor) {.cdecl.}
  proc DestroyLocalOscHandler*(local_osc_handler: pointer) {.cdecl.}
  proc DoActionShortcutDialog*(hwnd: HWND; section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint): bool {.cdecl.}
  proc Dock_UpdateDockID*(ident_str: cstring; whichDock: cint) {.cdecl.}
  proc DockGetPosition*(whichDock: cint): cint {.cdecl.}
  proc DockIsChildOfDock*(hwnd: HWND; isFloatingDockerOut: ptr bool): cint {.cdecl.}
  proc DockWindowActivate*(hwnd: HWND) {.cdecl.}
  proc DockWindowAdd*(hwnd: HWND; name: cstring; pos: cint; allowShow: bool) {.cdecl.}
  proc DockWindowAddEx*(hwnd: HWND; name: cstring; identstr: cstring; allowShow: bool) {.cdecl.}
  proc DockWindowRefresh*() {.cdecl.}
  proc DockWindowRefreshForHWND*(hwnd: HWND) {.cdecl.}
  proc DockWindowRemove*(hwnd: HWND) {.cdecl.}
  proc DuplicateCustomizableMenu*(srcmenu: pointer; destmenu: pointer): bool {.cdecl.}
  proc EditTempoTimeSigMarker*(project: ReaProject; markerindex: cint): bool {.cdecl.}
  proc EnsureNotCompletelyOffscreen*(rInOut: ptr RECT) {.cdecl.}
  proc EnumerateFiles*(path: cstring; fileindex: cint): cstring {.cdecl.}
  proc EnumerateSubdirectories*(path: cstring; subdirindex: cint): cstring {.cdecl.}
  proc EnumPitchShiftModes*(mode: cint; strOut: cstringArray): bool {.cdecl.}
  proc EnumPitchShiftSubModes*(mode: cint; submode: cint): cstring {.cdecl.}
  proc EnumProjectMarkers*(idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint): cint {.cdecl.}
  proc EnumProjectMarkers2*(proj: ReaProject; idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint): cint {.cdecl.}
  proc EnumProjectMarkers3*(proj: ReaProject; idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint; colorOut: ptr cint): cint {.cdecl.}
  proc EnumProjects*(idx: cint; projfnOutOptional: cstring; projfnOutOptional_sz: cint): ReaProject {.cdecl.}
  proc EnumProjExtState*(proj: ReaProject; extname: cstring; idx: cint; keyOutOptional: cstring; keyOutOptional_sz: cint; valOutOptional: cstring; valOutOptional_sz: cint): bool {.cdecl.}
  proc EnumRegionRenderMatrix*(proj: ReaProject; regionindex: cint; rendertrack: cint): MediaTrack {.cdecl.}
  proc EnumTrackMIDIProgramNames*(track: cint; programNumber: cint; programName: cstring; programName_sz: cint): bool {.cdecl.}
  proc EnumTrackMIDIProgramNamesEx*(proj: ReaProject; track: MediaTrack; programNumber: cint; programName: cstring; programName_sz: cint): bool {.cdecl.}
  proc Envelope_Evaluate*(envelope: TrackEnvelope; time: cdouble; samplerate: cdouble; samplesRequested: cint; valueOutOptional: ptr cdouble; dVdSOutOptional: ptr cdouble; ddVdSOutOptional: ptr cdouble; dddVdSOutOptional: ptr cdouble): cint {.cdecl.}
  proc Envelope_FormatValue*(env: TrackEnvelope; value: cdouble; bufOut: cstring; bufOut_sz: cint) {.cdecl.}
  proc Envelope_GetParentTake*(env: TrackEnvelope; indexOutOptional: ptr cint; index2OutOptional: ptr cint): MediaItem_Take {.cdecl.}
  proc Envelope_GetParentTrack*(env: TrackEnvelope; indexOutOptional: ptr cint; index2OutOptional: ptr cint): MediaTrack {.cdecl.}
  proc Envelope_SortPoints*(envelope: TrackEnvelope): bool {.cdecl.}
  proc Envelope_SortPointsEx*(envelope: TrackEnvelope; autoitem_idx: cint): bool {.cdecl.}
  proc ExecProcess*(cmdline: cstring; timeoutmsec: cint): cstring {.cdecl.}
  proc file_exists*(path: cstring): bool {.cdecl.}
  proc FindTempoTimeSigMarker*(project: ReaProject; time: cdouble): cint {.cdecl.}
  proc format_timestr*(tpos: cdouble; buf: cstring; buf_sz: cint) {.cdecl.}
  proc format_timestr_len*(tpos: cdouble; buf: cstring; buf_sz: cint; offset: cdouble; modeoverride: cint) {.cdecl.}
  proc format_timestr_pos*(tpos: cdouble; buf: cstring; buf_sz: cint; modeoverride: cint) {.cdecl.}
  proc FreeHeapPtr*(`ptr`: pointer) {.cdecl.}
  proc genGuid*(g: ptr GUID) {.cdecl.}
  proc get_config_var*(name: cstring; szOut: ptr cint): pointer {.cdecl.}
  proc get_config_var_string*(name: cstring; bufOut: cstring; bufOut_sz: cint): bool {.cdecl.}
  proc get_ini_file*(): cstring {.cdecl.}
  proc get_midi_config_var*(name: cstring; szOut: ptr cint): pointer {.cdecl.}
  proc GetActionShortcutDesc*(section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint; desc: cstring; desclen: cint): bool {.cdecl.}
  proc GetActiveTake*(item: MediaItem): MediaItem_Take {.cdecl.}
  proc GetAllProjectPlayStates*(ignoreProject: ReaProject): cint {.cdecl.}
  proc GetAppVersion*(): cstring {.cdecl.}
  proc GetArmedCommand*(secOut: cstring; secOut_sz: cint): cint {.cdecl.}
  proc GetAudioAccessorEndTime*(accessor: ptr AudioAccessor): cdouble {.cdecl.}
  proc GetAudioAccessorHash*(accessor: ptr AudioAccessor; hashNeed128: cstring) {.cdecl.}
  proc GetAudioAccessorSamples*(accessor: ptr AudioAccessor; samplerate: cint; numchannels: cint; starttime_sec: cdouble; numsamplesperchannel: cint; samplebuffer: ptr cdouble): cint {.cdecl.}
  proc GetAudioAccessorStartTime*(accessor: ptr AudioAccessor): cdouble {.cdecl.}
  proc GetAudioDeviceInfo*(attribute: cstring; desc: cstring; desc_sz: cint): bool {.cdecl.}
  proc GetColorTheme*(idx: cint; defval: cint): INT_PTR {.cdecl.}
  proc GetColorThemeStruct*(szOut: ptr cint): pointer {.cdecl.}
  proc GetConfigWantsDock*(ident_str: cstring): cint {.cdecl.}
  proc GetContextMenu*(idx: cint): HMENU {.cdecl.}
  proc GetCurrentProjectInLoadSave*(): ReaProject {.cdecl.}
  proc GetCursorContext*(): cint {.cdecl.}
  proc GetCursorContext2*(want_last_valid: bool): cint {.cdecl.}
  proc GetCursorPosition*(): cdouble {.cdecl.}
  proc GetCursorPositionEx*(proj: ReaProject): cdouble {.cdecl.}
  proc GetDisplayedMediaItemColor*(item: MediaItem): cint {.cdecl.}
  proc GetDisplayedMediaItemColor2*(item: MediaItem; take: MediaItem_Take): cint {.cdecl.}
  proc GetEnvelopeInfo_Value*(tr: TrackEnvelope; parmname: cstring): cdouble {.cdecl.}
  proc GetEnvelopeName*(env: TrackEnvelope; bufOut: cstring; bufOut_sz: cint): bool {.cdecl.}
  proc GetEnvelopePoint*(envelope: TrackEnvelope; ptidx: cint; timeOutOptional: ptr cdouble; valueOutOptional: ptr cdouble; shapeOutOptional: ptr cint; tensionOutOptional: ptr cdouble; selectedOutOptional: ptr bool): bool {.cdecl.}
  proc GetEnvelopePointByTime*(envelope: TrackEnvelope; time: cdouble): cint {.cdecl.}
  proc GetEnvelopePointByTimeEx*(envelope: TrackEnvelope; autoitem_idx: cint; time: cdouble): cint {.cdecl.}
  proc GetEnvelopePointEx*(envelope: TrackEnvelope; autoitem_idx: cint; ptidx: cint; timeOutOptional: ptr cdouble; valueOutOptional: ptr cdouble; shapeOutOptional: ptr cint; tensionOutOptional: ptr cdouble; selectedOutOptional: ptr bool): bool {.cdecl.}
  proc GetEnvelopeScalingMode*(env: TrackEnvelope): cint {.cdecl.}
  proc GetEnvelopeStateChunk*(env: TrackEnvelope; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool {.cdecl.}
  proc GetExePath*(): cstring {.cdecl.}
  proc GetExtState*(section: cstring; key: cstring): cstring {.cdecl.}
  proc GetFocusedFX*(tracknumberOut: ptr cint; itemnumberOut: ptr cint; fxnumberOut: ptr cint): cint {.cdecl.}
  proc GetFocusedFX2*(tracknumberOut: ptr cint; itemnumberOut: ptr cint; fxnumberOut: ptr cint): cint {.cdecl.}
  proc GetFreeDiskSpaceForRecordPath*(proj: ReaProject; pathidx: cint): cint {.cdecl.}
  proc GetFXEnvelope*(track: MediaTrack; fxindex: cint; parameterindex: cint; create: bool): TrackEnvelope {.cdecl.}
  proc GetGlobalAutomationOverride*(): cint {.cdecl.}
  proc GetHZoomLevel*(): cdouble {.cdecl.}
  proc GetIconThemePointer*(name: cstring): pointer {.cdecl.}
  proc GetIconThemePointerForDPI*(name: cstring; dpisc: cint): pointer {.cdecl.}
  proc GetIconThemeStruct*(szOut: ptr cint): pointer {.cdecl.}
  proc GetInputChannelName*(channelIndex: cint): cstring {.cdecl.}
  proc GetInputOutputLatency*(inputlatencyOut: ptr cint; outputLatencyOut: ptr cint) {.cdecl.}
  # proc GetItemEditingTime2*(which_itemOut: PCM_source; flagsOut: ptr cint): cdouble {.cdecl.}
  proc GetItemFromPoint*(screen_x: cint; screen_y: cint; allow_locked: bool; takeOutOptional: ptr MediaItem_Take): MediaItem {.cdecl.}
  proc GetItemProjectContext*(item: MediaItem): ReaProject {.cdecl.}
  proc GetItemStateChunk*(item: MediaItem; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool {.cdecl.}
  proc GetLastColorThemeFile*(): cstring {.cdecl.}
  proc GetLastMarkerAndCurRegion*(proj: ReaProject; time: cdouble; markeridxOut: ptr cint; regionidxOut: ptr cint) {.cdecl.}
  proc GetLastTouchedFX*(tracknumberOut: ptr cint; fxnumberOut: ptr cint; paramnumberOut: ptr cint): bool {.cdecl.}
  proc GetLastTouchedTrack*(): MediaTrack {.cdecl.}
  proc GetMainHwnd*(): HWND {.cdecl.}
  proc GetMasterMuteSoloFlags*(): cint {.cdecl.}
  proc GetMasterTrack*(proj: ReaProject): MediaTrack {.cdecl.}
  proc GetMasterTrackVisibility*(): cint {.cdecl.}
  proc GetMaxMidiInputs*(): cint {.cdecl.}
  proc GetMaxMidiOutputs*(): cint {.cdecl.}
  proc GetMediaFileMetadata*(mediaSource: PCM_source; identifier: cstring; bufOutNeedBig: cstring; bufOutNeedBig_sz: cint): cint {.cdecl.}
  proc GetMediaItem*(proj: ReaProject; itemidx: cint): MediaItem {.cdecl.}
  proc GetMediaItemInfo_Value*(item: MediaItem; parmname: cstring): cdouble {.cdecl.}
  proc GetMediaItemNumTakes*(item: MediaItem): cint {.cdecl.}
  proc GetMediaItemTake*(item: MediaItem; tk: cint): MediaItem_Take {.cdecl.}
  proc GetMediaItemTake_Item*(take: MediaItem_Take): MediaItem {.cdecl.}
  proc GetMediaItemTake_Peaks*(take: MediaItem_Take; peakrate: cdouble; starttime: cdouble; numchannels: cint; numsamplesperchannel: cint; want_extra_type: cint; buf: ptr cdouble): cint {.cdecl.}
  proc GetMediaItemTake_Source*(take: MediaItem_Take): PCM_source {.cdecl.}
  proc GetMediaItemTake_Track*(take: MediaItem_Take): MediaTrack {.cdecl.}
  proc GetMediaItemTakeByGUID*(project: ReaProject; guid: ptr GUID): MediaItem_Take {.cdecl.}
  proc GetMediaItemTakeInfo_Value*(take: MediaItem_Take; parmname: cstring): cdouble {.cdecl.}
  proc GetMediaItemTrack*(item: MediaItem): MediaTrack {.cdecl.}
  proc GetMediaSourceFileName*(source: PCM_source; filenamebuf: cstring; filenamebuf_sz: cint) {.cdecl.}
  proc GetMediaSourceLength*(source: PCM_source; lengthIsQNOut: ptr bool): cdouble {.cdecl.}
  proc GetMediaSourceNumChannels*(source: PCM_source): cint {.cdecl.}
  proc GetMediaSourceParent*(src: PCM_source): PCM_source {.cdecl.}
  proc GetMediaSourceSampleRate*(source: PCM_source): cint {.cdecl.}
  proc GetMediaSourceType*(source: PCM_source; typebuf: cstring; typebuf_sz: cint) {.cdecl.}
  proc GetMediaTrackInfo_Value*(tr: MediaTrack; parmname: cstring): cdouble {.cdecl.}
  proc GetMIDIInputName*(dev: cint; nameout: cstring; nameout_sz: cint): bool {.cdecl.}
  proc GetMIDIOutputName*(dev: cint; nameout: cstring; nameout_sz: cint): bool {.cdecl.}
  proc GetMixerScroll*(): MediaTrack {.cdecl.}
  proc GetMouseModifier*(context: cstring; modifier_flag: cint; action: cstring; action_sz: cint) {.cdecl.}
  proc GetMousePosition*(xOut: ptr cint; yOut: ptr cint) {.cdecl.}
  proc GetNumAudioInputs*(): cint {.cdecl.}
  proc GetNumAudioOutputs*(): cint {.cdecl.}
  proc GetNumMIDIInputs*(): cint {.cdecl.}
  proc GetNumMIDIOutputs*(): cint {.cdecl.}
  proc GetNumTakeMarkers*(take: MediaItem_Take): cint {.cdecl.}
  proc GetNumTracks*(): cint {.cdecl.}
  proc GetOS*(): cstring {.cdecl.}
  proc GetOutputChannelName*(channelIndex: cint): cstring {.cdecl.}
  proc GetOutputLatency*(): cdouble {.cdecl.}
  proc GetParentTrack*(track: MediaTrack): MediaTrack {.cdecl.}
  proc GetPeakFileName*(fn: cstring; buf: cstring; buf_sz: cint) {.cdecl.}
  proc GetPeakFileNameEx*(fn: cstring; buf: cstring; buf_sz: cint; forWrite: bool) {.cdecl.}
  proc GetPeakFileNameEx2*(fn: cstring; buf: cstring; buf_sz: cint; forWrite: bool; peaksfileextension: cstring) {.cdecl.}
  # proc GetPeaksBitmap*(pks: ptr PCM_source_peaktransfer_t; maxamp: cdouble; w: cint; h: cint; bmp: LICE_IBitmap): pointer {.cdecl.}
  proc GetPlayPosition*(): cdouble {.cdecl.}
  proc GetPlayPosition2*(): cdouble {.cdecl.}
  proc GetPlayPosition2Ex*(proj: ReaProject): cdouble {.cdecl.}
  proc GetPlayPositionEx*(proj: ReaProject): cdouble {.cdecl.}
  proc GetPlayState*(): cint {.cdecl.}
  proc GetPlayStateEx*(proj: ReaProject): cint {.cdecl.}
  proc GetPreferredDiskReadMode*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.cdecl.}
  proc GetPreferredDiskReadModePeak*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.cdecl.}
  proc GetPreferredDiskWriteMode*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.cdecl.}
  proc GetProjectLength*(proj: ReaProject): cdouble {.cdecl.}
  proc GetProjectName*(proj: ReaProject; buf: cstring; buf_sz: cint) {.cdecl.}
  proc GetProjectPath*(buf: cstring; buf_sz: cint) {.cdecl.}
  proc GetProjectPathEx*(proj: ReaProject; buf: cstring; buf_sz: cint) {.cdecl.}
  proc GetProjectStateChangeCount*(proj: ReaProject): cint {.cdecl.}
  proc GetProjectTimeOffset*(proj: ReaProject; rndframe: bool): cdouble {.cdecl.}
  proc GetProjectTimeSignature*(bpmOut: ptr cdouble; bpiOut: ptr cdouble) {.cdecl.}
  proc GetProjectTimeSignature2*(proj: ReaProject; bpmOut: ptr cdouble; bpiOut: ptr cdouble) {.cdecl.}
  proc GetProjExtState*(proj: ReaProject; extname: cstring; key: cstring; valOutNeedBig: cstring; valOutNeedBig_sz: cint): cint {.cdecl.}
  proc GetResourcePath*(): cstring {.cdecl.}
  proc GetSelectedEnvelope*(proj: ReaProject): TrackEnvelope {.cdecl.}
  proc GetSelectedMediaItem*(proj: ReaProject; selitem: cint): MediaItem {.cdecl.}
  proc GetSelectedTrack*(proj: ReaProject; seltrackidx: cint): MediaTrack {.cdecl.}
  proc GetSelectedTrack2*(proj: ReaProject; seltrackidx: cint; wantmaster: bool): MediaTrack {.cdecl.}
  proc GetSelectedTrackEnvelope*(proj: ReaProject): TrackEnvelope {.cdecl.}
  proc GetSet_ArrangeView2*(proj: ReaProject; isSet: bool; screen_x_start: cint; screen_x_end: cint; start_timeOut: ptr cdouble; end_timeOut: ptr cdouble) {.cdecl.}
  proc GetSet_LoopTimeRange*(isSet: bool; isLoop: bool; startOut: ptr cdouble; endOut: ptr cdouble; allowautoseek: bool) {.cdecl.}
  proc GetSet_LoopTimeRange2*(proj: ReaProject; isSet: bool; isLoop: bool; startOut: ptr cdouble; endOut: ptr cdouble; allowautoseek: bool) {.cdecl.}
  proc GetSetAutomationItemInfo*(env: TrackEnvelope; autoitem_idx: cint; desc: cstring; value: cdouble; is_set: bool): cdouble {.cdecl.}
  proc GetSetAutomationItemInfo_String*(env: TrackEnvelope; autoitem_idx: cint; desc: cstring; valuestrNeedBig: cstring; is_set: bool): bool {.cdecl.}
  proc GetSetEnvelopeInfo_String*(env: TrackEnvelope; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.cdecl.}
  proc GetSetEnvelopeState*(env: TrackEnvelope; str: cstring; str_sz: cint): bool {.cdecl.}
  proc GetSetEnvelopeState2*(env: TrackEnvelope; str: cstring; str_sz: cint; isundo: bool): bool {.cdecl.}
  proc GetSetItemState*(item: MediaItem; str: cstring; str_sz: cint): bool {.cdecl.}
  proc GetSetItemState2*(item: MediaItem; str: cstring; str_sz: cint; isundo: bool): bool {.cdecl.}
  proc GetSetMediaItemInfo*(item: MediaItem; parmname: cstring; setNewValue: pointer): pointer {.cdecl.}
  proc GetSetMediaItemInfo_String*(item: MediaItem; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.cdecl.}
  proc GetSetMediaItemTakeInfo*(tk: MediaItem_Take; parmname: cstring; setNewValue: pointer): pointer {.cdecl.}
  proc GetSetMediaItemTakeInfo_String*(tk: MediaItem_Take; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.cdecl.}
  proc GetSetMediaTrackInfo*(tr: MediaTrack; parmname: cstring; setNewValue: pointer): pointer {.cdecl.}
  proc GetSetMediaTrackInfo_String*(tr: MediaTrack; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.cdecl.}
  proc GetSetObjectState*(obj: pointer; str: cstring): cstring {.cdecl.}
  proc GetSetObjectState2*(obj: pointer; str: cstring; isundo: bool): cstring {.cdecl.}
  proc GetSetProjectAuthor*(proj: ReaProject; set: bool; author: cstring; author_sz: cint) {.cdecl.}
  proc GetSetProjectGrid*(project: ReaProject; set: bool; divisionInOutOptional: ptr cdouble; swingmodeInOutOptional: ptr cint; swingamtInOutOptional: ptr cdouble): cint {.cdecl.}
  proc GetSetProjectInfo*(project: ReaProject; desc: cstring; value: cdouble; is_set: bool): cdouble {.cdecl.}
  proc GetSetProjectInfo_String*(project: ReaProject; desc: cstring; valuestrNeedBig: cstring; is_set: bool): bool {.cdecl.}
  proc GetSetProjectNotes*(proj: ReaProject; set: bool; notesNeedBig: cstring; notesNeedBig_sz: cint) {.cdecl.}
  proc GetSetRepeat*(val: cint): cint {.cdecl.}
  proc GetSetRepeatEx*(proj: ReaProject; val: cint): cint {.cdecl.}
  proc GetSetTrackGroupMembership*(tr: MediaTrack; groupname: cstring; setmask: cuint; setvalue: cuint): cuint {.cdecl.}
  proc GetSetTrackGroupMembershipHigh*(tr: MediaTrack; groupname: cstring; setmask: cuint; setvalue: cuint): cuint {.cdecl.}
  proc GetSetTrackMIDISupportFile*(proj: ReaProject; track: MediaTrack; which: cint; filename: cstring): cstring {.cdecl.}
  proc GetSetTrackSendInfo*(tr: MediaTrack; category: cint; sendidx: cint; parmname: cstring; setNewValue: pointer): pointer {.cdecl.}
  proc GetSetTrackSendInfo_String*(tr: MediaTrack; category: cint; sendidx: cint; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.cdecl.}
  proc GetSetTrackState*(track: MediaTrack; str: cstring; str_sz: cint): bool {.cdecl.}
  proc GetSetTrackState2*(track: MediaTrack; str: cstring; str_sz: cint; isundo: bool): bool {.cdecl.}
  proc GetSubProjectFromSource*(src: PCM_source): ReaProject {.cdecl.}
  proc GetTake*(item: MediaItem; takeidx: cint): MediaItem_Take {.cdecl.}
  proc GetTakeEnvelope*(take: MediaItem_Take; envidx: cint): TrackEnvelope {.cdecl.}
  proc GetTakeEnvelopeByName*(take: MediaItem_Take; envname: cstring): TrackEnvelope {.cdecl.}
  proc GetTakeMarker*(take: MediaItem_Take; idx: cint; nameOut: cstring; nameOut_sz: cint; colorOutOptional: ptr cint): cdouble {.cdecl.}
  proc GetTakeName*(take: MediaItem_Take): cstring {.cdecl.}
  proc GetTakeNumStretchMarkers*(take: MediaItem_Take): cint {.cdecl.}
  proc GetTakeStretchMarker*(take: MediaItem_Take; idx: cint; posOut: ptr cdouble; srcposOutOptional: ptr cdouble): cint {.cdecl.}
  proc GetTakeStretchMarkerSlope*(take: MediaItem_Take; idx: cint): cdouble {.cdecl.}
  proc GetTCPFXParm*(project: ReaProject; track: MediaTrack; index: cint; fxindexOut: ptr cint; parmidxOut: ptr cint): bool {.cdecl.}
  proc GetTempoMatchPlayRate*(source: PCM_source; srcscale: cdouble; position: cdouble; mult: cdouble; rateOut: ptr cdouble; targetlenOut: ptr cdouble): bool {.cdecl.}
  proc GetTempoTimeSigMarker*(proj: ReaProject; ptidx: cint; timeposOut: ptr cdouble; measureposOut: ptr cint; beatposOut: ptr cdouble; bpmOut: ptr cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; lineartempoOut: ptr bool): bool {.cdecl.}
  proc GetThemeColor*(ini_key: cstring; flagsOptional: cint): cint {.cdecl.}
  proc GetToggleCommandState*(command_id: cint): cint {.cdecl.}
  proc GetToggleCommandState2*(section: ptr KbdSectionInfo; command_id: cint): cint {.cdecl.}
  proc GetToggleCommandStateEx*(section_id: cint; command_id: cint): cint {.cdecl.}
  proc GetToggleCommandStateThroughHooks*(section: ptr KbdSectionInfo; command_id: cint): cint {.cdecl.}
  proc GetTooltipWindow*(): HWND {.cdecl.}
  proc GetTrack*(proj: ReaProject; trackidx: cint): MediaTrack {.cdecl.}
  proc GetTrackAutomationMode*(tr: MediaTrack): cint {.cdecl.}
  proc GetTrackColor*(track: MediaTrack): cint {.cdecl.}
  proc GetTrackDepth*(track: MediaTrack): cint {.cdecl.}
  proc GetTrackEnvelope*(track: MediaTrack; envidx: cint): TrackEnvelope {.cdecl.}
  proc GetTrackEnvelopeByChunkName*(tr: MediaTrack; cfgchunkname: cstring): TrackEnvelope {.cdecl.}
  proc GetTrackEnvelopeByName*(track: MediaTrack; envname: cstring): TrackEnvelope {.cdecl.}
  proc GetTrackFromPoint*(screen_x: cint; screen_y: cint; infoOutOptional: ptr cint): MediaTrack {.cdecl.}
  proc GetTrackGUID*(tr: MediaTrack): ptr GUID {.cdecl.}
  proc GetTrackInfo*(track: INT_PTR; flags: ptr cint): cstring {.cdecl.}
  proc GetTrackMediaItem*(tr: MediaTrack; itemidx: cint): MediaItem {.cdecl.}
  proc GetTrackMIDILyrics*(track: MediaTrack; flag: cint; bufWantNeedBig: cstring; bufWantNeedBig_sz: ptr cint): bool {.cdecl.}
  proc GetTrackMIDINoteName*(track: cint; pitch: cint; chan: cint): cstring {.cdecl.}
  proc GetTrackMIDINoteNameEx*(proj: ReaProject; track: MediaTrack; pitch: cint; chan: cint): cstring {.cdecl.}
  proc GetTrackMIDINoteRange*(proj: ReaProject; track: MediaTrack; note_loOut: ptr cint; note_hiOut: ptr cint) {.cdecl.}
  proc GetTrackName*(track: MediaTrack; bufOut: cstring; bufOut_sz: cint): bool {.cdecl.}
  proc GetTrackNumMediaItems*(tr: MediaTrack): cint {.cdecl.}
  proc GetTrackNumSends*(tr: MediaTrack; category: cint): cint {.cdecl.}
  proc GetTrackReceiveName*(track: MediaTrack; recv_index: cint; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc GetTrackReceiveUIMute*(track: MediaTrack; recv_index: cint; muteOut: ptr bool): bool {.cdecl.}
  proc GetTrackReceiveUIVolPan*(track: MediaTrack; recv_index: cint; volumeOut: ptr cdouble; panOut: ptr cdouble): bool {.cdecl.}
  proc GetTrackSendInfo_Value*(tr: MediaTrack; category: cint; sendidx: cint; parmname: cstring): cdouble {.cdecl.}
  proc GetTrackSendName*(track: MediaTrack; send_index: cint; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc GetTrackSendUIMute*(track: MediaTrack; send_index: cint; muteOut: ptr bool): bool {.cdecl.}
  proc GetTrackSendUIVolPan*(track: MediaTrack; send_index: cint; volumeOut: ptr cdouble; panOut: ptr cdouble): bool {.cdecl.}
  proc GetTrackState*(track: MediaTrack; flagsOut: ptr cint): cstring {.cdecl.}
  proc GetTrackStateChunk*(track: MediaTrack; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool {.cdecl.}
  proc GetTrackUIMute*(track: MediaTrack; muteOut: ptr bool): bool {.cdecl.}
  proc GetTrackUIPan*(track: MediaTrack; pan1Out: ptr cdouble; pan2Out: ptr cdouble; panmodeOut: ptr cint): bool {.cdecl.}
  proc GetTrackUIVolPan*(track: MediaTrack; volumeOut: ptr cdouble; panOut: ptr cdouble): bool {.cdecl.}
  proc GetUnderrunTime*(audio_xrunOutOptional: ptr cuint; media_xrunOutOptional: ptr cuint; curtimeOutOptional: ptr cuint) {.cdecl.}
  proc GetUserFileNameForRead*(filenameNeed4096: cstring; title: cstring; defext: cstring): bool {.cdecl.}
  proc GetUserInputs*(title: cstring; num_inputs: cint; captions_csv: cstring; retvals_csv: cstring; retvals_csv_sz: cint): bool {.cdecl.}
  proc GoToMarker*(proj: ReaProject; marker_index: cint; use_timeline_order: bool) {.cdecl.}
  proc GoToRegion*(proj: ReaProject; region_index: cint; use_timeline_order: bool) {.cdecl.}
  proc GR_SelectColor*(hwnd: HWND; colorOut: ptr cint): cint {.cdecl.}
  proc GSC_mainwnd*(t: cint): cint {.cdecl.}
  proc guidToString*(g: ptr GUID; destNeed64: cstring) {.cdecl.}
  proc HasExtState*(section: cstring; key: cstring): bool {.cdecl.}
  proc HasTrackMIDIPrograms*(track: cint): cstring {.cdecl.}
  proc HasTrackMIDIProgramsEx*(proj: ReaProject; track: MediaTrack): cstring {.cdecl.}
  proc Help_Set*(helpstring: cstring; is_temporary_help: bool) {.cdecl.}
  # proc HiresPeaksFromSource*(src: PCM_source; `block`: ptr PCM_source_peaktransfer_t) {.cdecl.}
  proc image_resolve_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.cdecl.}
  proc InsertAutomationItem*(env: TrackEnvelope; pool_id: cint; position: cdouble; length: cdouble): cint {.cdecl.}
  proc InsertEnvelopePoint*(envelope: TrackEnvelope; time: cdouble; value: cdouble; shape: cint; tension: cdouble; selected: bool; noSortInOptional: ptr bool): bool {.cdecl.}
  proc InsertEnvelopePointEx*(envelope: TrackEnvelope; autoitem_idx: cint; time: cdouble; value: cdouble; shape: cint; tension: cdouble; selected: bool; noSortInOptional: ptr bool): bool {.cdecl.}
  proc InsertMedia*(file: cstring; mode: cint): cint {.cdecl.}
  proc InsertMediaSection*(file: cstring; mode: cint; startpct: cdouble; endpct: cdouble; pitchshift: cdouble): cint {.cdecl.}
  proc InsertTrackAtIndex*(idx: cint; wantDefaults: bool) {.cdecl.}
  proc IsInRealTimeAudio*(): cint {.cdecl.}
  proc IsItemTakeActiveForPlayback*(item: MediaItem; take: MediaItem_Take): bool {.cdecl.}
  proc IsMediaExtension*(ext: cstring; wantOthers: bool): bool {.cdecl.}
  proc IsMediaItemSelected*(item: MediaItem): bool {.cdecl.}
  proc IsProjectDirty*(proj: ReaProject): cint {.cdecl.}
  proc IsREAPER*(): bool {.cdecl.}
  proc IsTrackSelected*(track: MediaTrack): bool {.cdecl.}
  proc IsTrackVisible*(track: MediaTrack; mixer: bool): bool {.cdecl.}
  proc joystick_create*(guid: ptr GUID): ptr joystick_device {.cdecl.}
  proc joystick_destroy*(device: ptr joystick_device) {.cdecl.}
  proc joystick_enum*(index: cint; namestrOutOptional: cstringArray): cstring {.cdecl.}
  proc joystick_getaxis*(dev: ptr joystick_device; axis: cint): cdouble {.cdecl.}
  proc joystick_getbuttonmask*(dev: ptr joystick_device): cuint {.cdecl.}
  proc joystick_getinfo*(dev: ptr joystick_device; axesOutOptional: ptr cint; povsOutOptional: ptr cint): cint {.cdecl.}
  proc joystick_getpov*(dev: ptr joystick_device; pov: cint): cdouble {.cdecl.}
  proc joystick_update*(dev: ptr joystick_device): bool {.cdecl.}
  proc kbd_enumerateActions*(section: ptr KbdSectionInfo; idx: cint; nameOut: cstringArray): cint {.cdecl.}
  # proc kbd_formatKeyName*(ac: ptr ACCEL; s: cstring) {.cdecl.}
  proc kbd_getCommandName*(cmd: cint; s: cstring; section: ptr KbdSectionInfo) {.cdecl.}
  proc kbd_getTextFromCmd*(cmd: DWORD; section: ptr KbdSectionInfo): cstring {.cdecl.}
  proc KBD_OnMainActionEx*(cmd: cint; val: cint; valhw: cint; relmode: cint; hwnd: HWND; proj: ReaProject): cint {.cdecl.}
  proc kbd_OnMidiEvent*(evt: ptr MIDI_event_t; dev_index: cint) {.cdecl.}
  # proc kbd_OnMidiList*(list: ptr MIDI_eventlist; dev_index: cint) {.cdecl.}
  proc kbd_ProcessActionsMenu*(menu: HMENU; section: ptr KbdSectionInfo) {.cdecl.}
  proc kbd_processMidiEventActionEx*(evt: ptr MIDI_event_t; section: ptr KbdSectionInfo; hwndCtx: HWND): bool {.cdecl.}
  proc kbd_reprocessMenu*(menu: HMENU; section: ptr KbdSectionInfo) {.cdecl.}
  proc kbd_RunCommandThroughHooks*(section: ptr KbdSectionInfo; actionCommandID: ptr cint; val: ptr cint; valhw: ptr cint; relmode: ptr cint; hwnd: HWND): bool {.cdecl.}
  proc kbd_translateAccelerator*(hwnd: HWND; msg: ptr MSG; section: ptr KbdSectionInfo): cint {.cdecl.}
  proc kbd_translateMouse*(winmsg: pointer; midimsg: ptr cuchar): bool {.cdecl.}
  proc LocalizeString*(src_string: cstring; section: cstring; flagsOptional: cint): cstring {.cdecl.}
  proc Loop_OnArrow*(project: ReaProject; direction: cint): bool {.cdecl.}
  proc Main_OnCommand*(command: cint; flag: cint) {.cdecl.}
  proc Main_OnCommandEx*(command: cint; flag: cint; proj: ReaProject) {.cdecl.}
  proc Main_openProject*(name: cstring) {.cdecl.}
  proc Main_SaveProject*(proj: ReaProject; forceSaveAsInOptional: bool) {.cdecl.}
  proc Main_UpdateLoopInfo*(ignoremask: cint) {.cdecl.}
  proc MarkProjectDirty*(proj: ReaProject) {.cdecl.}
  proc MarkTrackItemsDirty*(track: MediaTrack; item: MediaItem) {.cdecl.}
  proc Master_GetPlayRate*(project: ReaProject): cdouble {.cdecl.}
  proc Master_GetPlayRateAtTime*(time_s: cdouble; proj: ReaProject): cdouble {.cdecl.}
  proc Master_GetTempo*(): cdouble {.cdecl.}
  proc Master_NormalizePlayRate*(playrate: cdouble; isnormalized: bool): cdouble {.cdecl.}
  proc Master_NormalizeTempo*(bpm: cdouble; isnormalized: bool): cdouble {.cdecl.}
  proc MB*(msg: cstring; title: cstring; `type`: cint): cint {.cdecl.}
  proc MediaItemDescendsFromTrack*(item: MediaItem; track: MediaTrack): cint {.cdecl.}
  proc MIDI_CountEvts*(take: MediaItem_Take; notecntOut: ptr cint; ccevtcntOut: ptr cint; textsyxevtcntOut: ptr cint): cint {.cdecl.}
  proc MIDI_DeleteCC*(take: MediaItem_Take; ccidx: cint): bool {.cdecl.}
  proc MIDI_DeleteEvt*(take: MediaItem_Take; evtidx: cint): bool {.cdecl.}
  proc MIDI_DeleteNote*(take: MediaItem_Take; noteidx: cint): bool {.cdecl.}
  proc MIDI_DeleteTextSysexEvt*(take: MediaItem_Take; textsyxevtidx: cint): bool {.cdecl.}
  proc MIDI_DisableSort*(take: MediaItem_Take) {.cdecl.}
  proc MIDI_EnumSelCC*(take: MediaItem_Take; ccidx: cint): cint {.cdecl.}
  proc MIDI_EnumSelEvts*(take: MediaItem_Take; evtidx: cint): cint {.cdecl.}
  proc MIDI_EnumSelNotes*(take: MediaItem_Take; noteidx: cint): cint {.cdecl.}
  proc MIDI_EnumSelTextSysexEvts*(take: MediaItem_Take; textsyxidx: cint): cint {.cdecl.}
  # proc MIDI_eventlist_Create*(): ptr MIDI_eventlist {.cdecl.}
  # proc MIDI_eventlist_Destroy*(evtlist: ptr MIDI_eventlist) {.cdecl.}
  proc MIDI_GetAllEvts*(take: MediaItem_Take; bufNeedBig: cstring; bufNeedBig_sz: ptr cint): bool {.cdecl.}
  proc MIDI_GetCC*(take: MediaItem_Take; ccidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; ppqposOut: ptr cdouble; chanmsgOut: ptr cint; chanOut: ptr cint; msg2Out: ptr cint; msg3Out: ptr cint): bool {.cdecl.}
  proc MIDI_GetCCShape*(take: MediaItem_Take; ccidx: cint; shapeOut: ptr cint; beztensionOut: ptr cdouble): bool {.cdecl.}
  proc MIDI_GetEvt*(take: MediaItem_Take; evtidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; ppqposOut: ptr cdouble; msg: cstring; msg_sz: ptr cint): bool {.cdecl.}
  proc MIDI_GetGrid*(take: MediaItem_Take; swingOutOptional: ptr cdouble; noteLenOutOptional: ptr cdouble): cdouble {.cdecl.}
  proc MIDI_GetHash*(take: MediaItem_Take; notesonly: bool; hash: cstring; hash_sz: cint): bool {.cdecl.}
  proc MIDI_GetNote*(take: MediaItem_Take; noteidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; startppqposOut: ptr cdouble; endppqposOut: ptr cdouble; chanOut: ptr cint; pitchOut: ptr cint; velOut: ptr cint): bool {.cdecl.}
  proc MIDI_GetPPQPos_EndOfMeasure*(take: MediaItem_Take; ppqpos: cdouble): cdouble {.cdecl.}
  proc MIDI_GetPPQPos_StartOfMeasure*(take: MediaItem_Take; ppqpos: cdouble): cdouble {.cdecl.}
  proc MIDI_GetPPQPosFromProjQN*(take: MediaItem_Take; projqn: cdouble): cdouble {.cdecl.}
  proc MIDI_GetPPQPosFromProjTime*(take: MediaItem_Take; projtime: cdouble): cdouble {.cdecl.}
  proc MIDI_GetProjQNFromPPQPos*(take: MediaItem_Take; ppqpos: cdouble): cdouble {.cdecl.}
  proc MIDI_GetProjTimeFromPPQPos*(take: MediaItem_Take; ppqpos: cdouble): cdouble {.cdecl.}
  proc MIDI_GetScale*(take: MediaItem_Take; rootOut: ptr cint; scaleOut: ptr cint; name: cstring; name_sz: cint): bool {.cdecl.}
  proc MIDI_GetTextSysexEvt*(take: MediaItem_Take; textsyxevtidx: cint; selectedOutOptional: ptr bool; mutedOutOptional: ptr bool; ppqposOutOptional: ptr cdouble; typeOutOptional: ptr cint; msgOptional: cstring; msgOptional_sz: ptr cint): bool {.cdecl.}
  proc MIDI_GetTrackHash*(track: MediaTrack; notesonly: bool; hash: cstring; hash_sz: cint): bool {.cdecl.}
  proc MIDI_InsertCC*(take: MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; chanmsg: cint; chan: cint; msg2: cint; msg3: cint): bool {.cdecl.}
  proc MIDI_InsertEvt*(take: MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; bytestr: cstring; bytestr_sz: cint): bool {.cdecl.}
  proc MIDI_InsertNote*(take: MediaItem_Take; selected: bool; muted: bool; startppqpos: cdouble; endppqpos: cdouble; chan: cint; pitch: cint; vel: cint; noSortInOptional: ptr bool): bool {.cdecl.}
  proc MIDI_InsertTextSysexEvt*(take: MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; `type`: cint; bytestr: cstring; bytestr_sz: cint): bool {.cdecl.}
  proc midi_reinit*() {.cdecl.}
  proc MIDI_SelectAll*(take: MediaItem_Take; select: bool) {.cdecl.}
  proc MIDI_SetAllEvts*(take: MediaItem_Take; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc MIDI_SetCC*(take: MediaItem_Take; ccidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; chanmsgInOptional: ptr cint; chanInOptional: ptr cint; msg2InOptional: ptr cint; msg3InOptional: ptr cint; noSortInOptional: ptr bool): bool {.cdecl.}
  proc MIDI_SetCCShape*(take: MediaItem_Take; ccidx: cint; shape: cint; beztension: cdouble; noSortInOptional: ptr bool): bool {.cdecl.}
  proc MIDI_SetEvt*(take: MediaItem_Take; evtidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; msgOptional: cstring; msgOptional_sz: cint; noSortInOptional: ptr bool): bool {.cdecl.}
  proc MIDI_SetItemExtents*(item: MediaItem; startQN: cdouble; endQN: cdouble): bool {.cdecl.}
  proc MIDI_SetNote*(take: MediaItem_Take; noteidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; startppqposInOptional: ptr cdouble; endppqposInOptional: ptr cdouble; chanInOptional: ptr cint; pitchInOptional: ptr cint; velInOptional: ptr cint; noSortInOptional: ptr bool): bool {.cdecl.}
  proc MIDI_SetTextSysexEvt*(take: MediaItem_Take; textsyxevtidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; typeInOptional: ptr cint; msgOptional: cstring; msgOptional_sz: cint; noSortInOptional: ptr bool): bool {.cdecl.}
  proc MIDI_Sort*(take: MediaItem_Take) {.cdecl.}
  proc MIDIEditor_GetActive*(): HWND {.cdecl.}
  proc MIDIEditor_GetMode*(midieditor: HWND): cint {.cdecl.}
  proc MIDIEditor_GetSetting_int*(midieditor: HWND; setting_desc: cstring): cint {.cdecl.}
  proc MIDIEditor_GetSetting_str*(midieditor: HWND; setting_desc: cstring; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc MIDIEditor_GetTake*(midieditor: HWND): MediaItem_Take {.cdecl.}
  proc MIDIEditor_LastFocused_OnCommand*(command_id: cint; islistviewcommand: bool): bool {.cdecl.}
  proc MIDIEditor_OnCommand*(midieditor: HWND; command_id: cint): bool {.cdecl.}
  proc MIDIEditor_SetSetting_int*(midieditor: HWND; setting_desc: cstring; setting: cint): bool {.cdecl.}
  proc mkpanstr*(strNeed64: cstring; pan: cdouble) {.cdecl.}
  proc mkvolpanstr*(strNeed64: cstring; vol: cdouble; pan: cdouble) {.cdecl.}
  proc mkvolstr*(strNeed64: cstring; vol: cdouble) {.cdecl.}
  proc MoveEditCursor*(adjamt: cdouble; dosel: bool) {.cdecl.}
  proc MoveMediaItemToTrack*(item: MediaItem; desttr: MediaTrack): bool {.cdecl.}
  proc MuteAllTracks*(mute: bool) {.cdecl.}
  proc my_getViewport*(r: ptr RECT; sr: ptr RECT; wantWorkArea: bool) {.cdecl.}
  proc NamedCommandLookup*(command_name: cstring): cint {.cdecl.}
  proc OnPauseButton*() {.cdecl.}
  proc OnPauseButtonEx*(proj: ReaProject) {.cdecl.}
  proc OnPlayButton*() {.cdecl.}
  proc OnPlayButtonEx*(proj: ReaProject) {.cdecl.}
  proc OnStopButton*() {.cdecl.}
  proc OnStopButtonEx*(proj: ReaProject) {.cdecl.}
  proc OpenColorThemeFile*(fn: cstring): bool {.cdecl.}
  proc OpenMediaExplorer*(mediafn: cstring; play: bool): HWND {.cdecl.}
  proc OscLocalMessageToHost*(message: cstring; valueInOptional: ptr cdouble) {.cdecl.}
  proc parse_timestr*(buf: cstring): cdouble {.cdecl.}
  proc parse_timestr_len*(buf: cstring; offset: cdouble; modeoverride: cint): cdouble {.cdecl.}
  proc parse_timestr_pos*(buf: cstring; modeoverride: cint): cdouble {.cdecl.}
  proc parsepanstr*(str: cstring): cdouble {.cdecl.}
  # proc PCM_Sink_Create*(filename: cstring; cfg: cstring; cfg_sz: cint; nch: cint; srate: cint; buildpeaks: bool): ptr PCM_sink {.cdecl.}
  # proc PCM_Sink_CreateEx*(proj: ReaProject; filename: cstring; cfg: cstring; cfg_sz: cint; nch: cint; srate: cint; buildpeaks: bool): ptr PCM_sink {.cdecl.}
  # proc PCM_Sink_CreateMIDIFile*(filename: cstring; cfg: cstring; cfg_sz: cint; bpm: cdouble; `div`: cint): ptr PCM_sink {.cdecl.}
  # proc PCM_Sink_CreateMIDIFileEx*(proj: ReaProject; filename: cstring; cfg: cstring; cfg_sz: cint; bpm: cdouble; `div`: cint): ptr PCM_sink {.cdecl.}
  proc PCM_Sink_Enum*(idx: cint; descstrOut: cstringArray): cuint {.cdecl.}
  proc PCM_Sink_GetExtension*(data: cstring; data_sz: cint): cstring {.cdecl.}
  proc PCM_Sink_ShowConfig*(cfg: cstring; cfg_sz: cint; hwndParent: HWND): HWND {.cdecl.}
  proc PCM_Source_CreateFromFile*(filename: cstring): PCM_source {.cdecl.}
  proc PCM_Source_CreateFromFileEx*(filename: cstring; forcenoMidiImp: bool): PCM_source {.cdecl.}
  # proc PCM_Source_CreateFromSimple*(dec: ptr ISimpleMediaDecoder; fn: cstring): PCM_source {.cdecl.}
  proc PCM_Source_CreateFromType*(sourcetype: cstring): PCM_source {.cdecl.}
  proc PCM_Source_Destroy*(src: PCM_source) {.cdecl.}
  proc PCM_Source_GetPeaks*(src: PCM_source; peakrate: cdouble; starttime: cdouble; numchannels: cint; numsamplesperchannel: cint; want_extra_type: cint; buf: ptr cdouble): cint {.cdecl.}
  proc PCM_Source_GetSectionInfo*(src: PCM_source; offsOut: ptr cdouble; lenOut: ptr cdouble; revOut: ptr bool): bool {.cdecl.}
  # proc PeakBuild_Create*(src: PCM_source; fn: cstring; srate: cint; nch: cint): ptr REAPER_PeakBuild_Interface {.cdecl.}
  # proc PeakBuild_CreateEx*(src: PCM_source; fn: cstring; srate: cint; nch: cint; flags: cint): ptr REAPER_PeakBuild_Interface {.cdecl.}
  # proc PeakGet_Create*(fn: cstring; srate: cint; nch: cint): ptr REAPER_PeakGet_Interface {.cdecl.}
  proc PitchShiftSubModeMenu*(hwnd: HWND; x: cint; y: cint; mode: cint; submode_sel: cint): cint {.cdecl.}
  # proc PlayPreview*(preview: ptr preview_register_t): cint {.cdecl.}
  # proc PlayPreviewEx*(preview: ptr preview_register_t; bufflags: cint; measure_align: cdouble): cint {.cdecl.}
  # proc PlayTrackPreview*(preview: ptr preview_register_t): cint {.cdecl.}
  # proc PlayTrackPreview2*(proj: ReaProject; preview: ptr preview_register_t): cint {.cdecl.}
  # proc PlayTrackPreview2Ex*(proj: ReaProject; preview: ptr preview_register_t; flags: cint; measure_align: cdouble): cint {.cdecl.}
  proc plugin_getapi*(name: cstring): pointer {.cdecl.}
  proc plugin_getFilterList*(): cstring {.cdecl.}
  proc plugin_getImportableProjectFilterList*(): cstring {.cdecl.}
  proc plugin_register*(name: cstring; infostruct: pointer): cint {.cdecl.}
  proc PluginWantsAlwaysRunFx*(amt: cint) {.cdecl.}
  proc PreventUIRefresh*(prevent_count: cint) {.cdecl.}
  proc projectconfig_var_addr*(proj: ReaProject; idx: cint): pointer {.cdecl.}
  proc projectconfig_var_getoffs*(name: cstring; szOut: ptr cint): cint {.cdecl.}
  proc PromptForAction*(session_mode: cint; init_id: cint; section_id: cint): cint {.cdecl.}
  proc realloc_cmd_ptr*(`ptr`: cstringArray; ptr_size: ptr cint; new_size: cint): bool {.cdecl.}
  # proc ReaperGetPitchShiftAPI*(version: cint): ptr IReaperPitchShift {.cdecl.}
  proc ReaScriptError*(errmsg: cstring) {.cdecl.}
  proc RecursiveCreateDirectory*(path: cstring; ignored: csize_t): cint {.cdecl.}
  proc reduce_open_files*(flags: cint): cint {.cdecl.}
  proc RefreshToolbar*(command_id: cint) {.cdecl.}
  proc RefreshToolbar2*(section_id: cint; command_id: cint) {.cdecl.}
  proc relative_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.cdecl.}
  proc RemoveTrackSend*(tr: MediaTrack; category: cint; sendidx: cint): bool {.cdecl.}
  proc RenderFileSection*(source_filename: cstring; target_filename: cstring; start_percent: cdouble; end_percent: cdouble; playrate: cdouble): bool {.cdecl.}
  proc ReorderSelectedTracks*(beforeTrackIdx: cint; makePrevFolder: cint): bool {.cdecl.}
  proc Resample_EnumModes*(mode: cint): cstring {.cdecl.}
  # proc Resampler_Create*(): ptr REAPER_Resample_Interface {.cdecl.}
  proc resolve_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.cdecl.}
  proc resolve_fn2*(`in`: cstring; `out`: cstring; out_sz: cint; checkSubDirOptional: cstring) {.cdecl.}
  proc ReverseNamedCommandLookup*(command_id: cint): cstring {.cdecl.}
  proc ScaleFromEnvelopeMode*(scaling_mode: cint; val: cdouble): cdouble {.cdecl.}
  proc ScaleToEnvelopeMode*(scaling_mode: cint; val: cdouble): cdouble {.cdecl.}
  proc screenset_register*(id: cstring; callbackFunc: pointer; param: pointer) {.cdecl.}
  # proc screenset_registerNew*(id: cstring; callbackFunc: screensetNewCallbackFunc; param: pointer) {.cdecl.}
  proc screenset_unregister*(id: cstring) {.cdecl.}
  proc screenset_unregisterByParam*(param: pointer) {.cdecl.}
  proc screenset_updateLastFocus*(prevWin: HWND) {.cdecl.}
  proc SectionFromUniqueID*(uniqueID: cint): ptr KbdSectionInfo {.cdecl.}
  proc SelectAllMediaItems*(proj: ReaProject; selected: bool) {.cdecl.}
  proc SelectProjectInstance*(proj: ReaProject) {.cdecl.}
  proc SendLocalOscMessage*(local_osc_handler: pointer; msg: cstring; msglen: cint) {.cdecl.}
  proc SetActiveTake*(take: MediaItem_Take) {.cdecl.}
  proc SetAutomationMode*(mode: cint; onlySel: bool) {.cdecl.}
  # proc SetCurrentBPM*(__proj: ReaProject; bpm: cdouble; wantUndo: bool) {.cdecl.}
  proc SetCursorContext*(mode: cint; envInOptional: TrackEnvelope) {.cdecl.}
  proc SetEditCurPos*(time: cdouble; moveview: bool; seekplay: bool) {.cdecl.}
  proc SetEditCurPos2*(proj: ReaProject; time: cdouble; moveview: bool; seekplay: bool) {.cdecl.}
  proc SetEnvelopePoint*(envelope: TrackEnvelope; ptidx: cint; timeInOptional: ptr cdouble; valueInOptional: ptr cdouble; shapeInOptional: ptr cint; tensionInOptional: ptr cdouble; selectedInOptional: ptr bool; noSortInOptional: ptr bool): bool {.cdecl.}
  proc SetEnvelopePointEx*(envelope: TrackEnvelope; autoitem_idx: cint; ptidx: cint; timeInOptional: ptr cdouble; valueInOptional: ptr cdouble; shapeInOptional: ptr cint; tensionInOptional: ptr cdouble; selectedInOptional: ptr bool; noSortInOptional: ptr bool): bool {.cdecl.}
  proc SetEnvelopeStateChunk*(env: TrackEnvelope; str: cstring; isundoOptional: bool): bool {.cdecl.}
  proc SetExtState*(section: cstring; key: cstring; value: cstring; persist: bool) {.cdecl.}
  proc SetGlobalAutomationOverride*(mode: cint) {.cdecl.}
  proc SetItemStateChunk*(item: MediaItem; str: cstring; isundoOptional: bool): bool {.cdecl.}
  proc SetMasterTrackVisibility*(flag: cint): cint {.cdecl.}
  proc SetMediaItemInfo_Value*(item: MediaItem; parmname: cstring; newvalue: cdouble): bool {.cdecl.}
  proc SetMediaItemLength*(item: MediaItem; length: cdouble; refreshUI: bool): bool {.cdecl.}
  proc SetMediaItemPosition*(item: MediaItem; position: cdouble; refreshUI: bool): bool {.cdecl.}
  proc SetMediaItemSelected*(item: MediaItem; selected: bool) {.cdecl.}
  # proc SetMediaItemTake_Source*(take: MediaItem_Take; source: PCM_source): bool {.cdecl.}
  proc SetMediaItemTakeInfo_Value*(take: MediaItem_Take; parmname: cstring; newvalue: cdouble): bool {.cdecl.}
  proc SetMediaTrackInfo_Value*(tr: MediaTrack; parmname: cstring; newvalue: cdouble): bool {.cdecl.}
  proc SetMIDIEditorGrid*(project: ReaProject; division: cdouble) {.cdecl.}
  proc SetMixerScroll*(leftmosttrack: MediaTrack): MediaTrack {.cdecl.}
  proc SetMouseModifier*(context: cstring; modifier_flag: cint; action: cstring) {.cdecl.}
  proc SetOnlyTrackSelected*(track: MediaTrack) {.cdecl.}
  proc SetProjectGrid*(project: ReaProject; division: cdouble) {.cdecl.}
  proc SetProjectMarker*(markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring): bool {.cdecl.}
  proc SetProjectMarker2*(proj: ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring): bool {.cdecl.}
  proc SetProjectMarker3*(proj: ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; color: cint): bool {.cdecl.}
  proc SetProjectMarker4*(proj: ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; color: cint; flags: cint): bool {.cdecl.}
  proc SetProjectMarkerByIndex*(proj: ReaProject; markrgnidx: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; IDnumber: cint; name: cstring; color: cint): bool {.cdecl.}
  proc SetProjectMarkerByIndex2*(proj: ReaProject; markrgnidx: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; IDnumber: cint; name: cstring; color: cint; flags: cint): bool {.cdecl.}
  proc SetProjExtState*(proj: ReaProject; extname: cstring; key: cstring; value: cstring): cint {.cdecl.}
  proc SetRegionRenderMatrix*(proj: ReaProject; regionindex: cint; track: MediaTrack; addorremove: cint) {.cdecl.}
  proc SetRenderLastError*(errorstr: cstring) {.cdecl.}
  proc SetTakeMarker*(take: MediaItem_Take; idx: cint; nameIn: cstring; srcposInOptional: ptr cdouble; colorInOptional: ptr cint): cint {.cdecl.}
  proc SetTakeStretchMarker*(take: MediaItem_Take; idx: cint; pos: cdouble; srcposInOptional: ptr cdouble): cint {.cdecl.}
  proc SetTakeStretchMarkerSlope*(take: MediaItem_Take; idx: cint; slope: cdouble): bool {.cdecl.}
  proc SetTempoTimeSigMarker*(proj: ReaProject; ptidx: cint; timepos: cdouble; measurepos: cint; beatpos: cdouble; bpm: cdouble; timesig_num: cint; timesig_denom: cint; lineartempo: bool): bool {.cdecl.}
  proc SetThemeColor*(ini_key: cstring; color: cint; flagsOptional: cint): cint {.cdecl.}
  proc SetToggleCommandState*(section_id: cint; command_id: cint; state: cint): bool {.cdecl.}
  proc SetTrackAutomationMode*(tr: MediaTrack; mode: cint) {.cdecl.}
  proc SetTrackColor*(track: MediaTrack; color: cint) {.cdecl.}
  proc SetTrackMIDILyrics*(track: MediaTrack; flag: cint; str: cstring): bool {.cdecl.}
  proc SetTrackMIDINoteName*(track: cint; pitch: cint; chan: cint; name: cstring): bool {.cdecl.}
  proc SetTrackMIDINoteNameEx*(proj: ReaProject; track: MediaTrack; pitch: cint; chan: cint; name: cstring): bool {.cdecl.}
  proc SetTrackSelected*(track: MediaTrack; selected: bool) {.cdecl.}
  proc SetTrackSendInfo_Value*(tr: MediaTrack; category: cint; sendidx: cint; parmname: cstring; newvalue: cdouble): bool {.cdecl.}
  proc SetTrackSendUIPan*(track: MediaTrack; send_idx: cint; pan: cdouble; isend: cint): bool {.cdecl.}
  proc SetTrackSendUIVol*(track: MediaTrack; send_idx: cint; vol: cdouble; isend: cint): bool {.cdecl.}
  proc SetTrackStateChunk*(track: MediaTrack; str: cstring; isundoOptional: bool): bool {.cdecl.}
  proc ShowActionList*(caller: ptr KbdSectionInfo; callerWnd: HWND) {.cdecl.}
  proc ShowConsoleMsg*(msg: cstring) {.cdecl.}
  proc ShowMessageBox*(msg: cstring; title: cstring; `type`: cint): cint {.cdecl.}
  proc ShowPopupMenu*(name: cstring; x: cint; y: cint; hwndParentOptional: HWND; ctxOptional: pointer; ctx2Optional: cint; ctx3Optional: cint) {.cdecl.}
  proc SLIDER2DB*(y: cdouble): cdouble {.cdecl.}
  proc SnapToGrid*(project: ReaProject; time_pos: cdouble): cdouble {.cdecl.}
  proc SoloAllTracks*(solo: cint) {.cdecl.}
  proc Splash_GetWnd*(): HWND {.cdecl.}
  proc SplitMediaItem*(item: MediaItem; position: cdouble): MediaItem {.cdecl.}
  # proc StopPreview*(preview: ptr preview_register_t): cint {.cdecl.}
  # proc StopTrackPreview*(preview: ptr preview_register_t): cint {.cdecl.}
  # proc StopTrackPreview2*(proj: pointer; preview: ptr preview_register_t): cint {.cdecl.}
  proc stringToGuid*(str: cstring; g: ptr GUID) {.cdecl.}
  proc StuffMIDIMessage*(mode: cint; msg1: cint; msg2: cint; msg3: cint) {.cdecl.}
  proc TakeFX_AddByName*(take: MediaItem_Take; fxname: cstring; instantiate: cint): cint {.cdecl.}
  proc TakeFX_CopyToTake*(src_take: MediaItem_Take; src_fx: cint; dest_take: MediaItem_Take; dest_fx: cint; is_move: bool) {.cdecl.}
  proc TakeFX_CopyToTrack*(src_take: MediaItem_Take; src_fx: cint; dest_track: MediaTrack; dest_fx: cint; is_move: bool) {.cdecl.}
  proc TakeFX_Delete*(take: MediaItem_Take; fx: cint): bool {.cdecl.}
  proc TakeFX_EndParamEdit*(take: MediaItem_Take; fx: cint; param: cint): bool {.cdecl.}
  proc TakeFX_FormatParamValue*(take: MediaItem_Take; fx: cint; param: cint; val: cdouble; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TakeFX_FormatParamValueNormalized*(take: MediaItem_Take; fx: cint; param: cint; value: cdouble; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TakeFX_GetChainVisible*(take: MediaItem_Take): cint {.cdecl.}
  proc TakeFX_GetCount*(take: MediaItem_Take): cint {.cdecl.}
  proc TakeFX_GetEnabled*(take: MediaItem_Take; fx: cint): bool {.cdecl.}
  proc TakeFX_GetEnvelope*(take: MediaItem_Take; fxindex: cint; parameterindex: cint; create: bool): TrackEnvelope {.cdecl.}
  proc TakeFX_GetFloatingWindow*(take: MediaItem_Take; index: cint): HWND {.cdecl.}
  proc TakeFX_GetFormattedParamValue*(take: MediaItem_Take; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TakeFX_GetFXGUID*(take: MediaItem_Take; fx: cint): ptr GUID {.cdecl.}
  proc TakeFX_GetFXName*(take: MediaItem_Take; fx: cint; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TakeFX_GetIOSize*(take: MediaItem_Take; fx: cint; inputPinsOutOptional: ptr cint; outputPinsOutOptional: ptr cint): cint {.cdecl.}
  proc TakeFX_GetNamedConfigParm*(take: MediaItem_Take; fx: cint; parmname: cstring; bufOut: cstring; bufOut_sz: cint): bool {.cdecl.}
  proc TakeFX_GetNumParams*(take: MediaItem_Take; fx: cint): cint {.cdecl.}
  proc TakeFX_GetOffline*(take: MediaItem_Take; fx: cint): bool {.cdecl.}
  proc TakeFX_GetOpen*(take: MediaItem_Take; fx: cint): bool {.cdecl.}
  proc TakeFX_GetParam*(take: MediaItem_Take; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble): cdouble {.cdecl.}
  proc TakeFX_GetParameterStepSizes*(take: MediaItem_Take; fx: cint; param: cint; stepOut: ptr cdouble; smallstepOut: ptr cdouble; largestepOut: ptr cdouble; istoggleOut: ptr bool): bool {.cdecl.}
  proc TakeFX_GetParamEx*(take: MediaItem_Take; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble; midvalOut: ptr cdouble): cdouble {.cdecl.}
  proc TakeFX_GetParamName*(take: MediaItem_Take; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TakeFX_GetParamNormalized*(take: MediaItem_Take; fx: cint; param: cint): cdouble {.cdecl.}
  proc TakeFX_GetPinMappings*(tr: MediaItem_Take; fx: cint; isoutput: cint; pin: cint; high32OutOptional: ptr cint): cint {.cdecl.}
  proc TakeFX_GetPreset*(take: MediaItem_Take; fx: cint; presetname: cstring; presetname_sz: cint): bool {.cdecl.}
  proc TakeFX_GetPresetIndex*(take: MediaItem_Take; fx: cint;numberOfPresetsOut: ptr cint): cint {.cdecl.}
  proc TakeFX_GetUserPresetFilename*(take: MediaItem_Take; fx: cint; fn: cstring; fn_sz: cint) {.cdecl.}
  proc TakeFX_NavigatePresets*(take: MediaItem_Take; fx: cint; presetmove: cint): bool {.cdecl.}
  proc TakeFX_SetEnabled*(take: MediaItem_Take; fx: cint; enabled: bool) {.cdecl.}
  proc TakeFX_SetNamedConfigParm*(take: MediaItem_Take; fx: cint; parmname: cstring; value: cstring): bool {.cdecl.}
  proc TakeFX_SetOffline*(take: MediaItem_Take; fx: cint; offline: bool) {.cdecl.}
  proc TakeFX_SetOpen*(take: MediaItem_Take; fx: cint; open: bool) {.cdecl.}
  proc TakeFX_SetParam*(take: MediaItem_Take; fx: cint; param: cint; val: cdouble): bool {.cdecl.}
  proc TakeFX_SetParamNormalized*(take: MediaItem_Take; fx: cint; param: cint; value: cdouble): bool {.cdecl.}
  proc TakeFX_SetPinMappings*(tr: MediaItem_Take; fx: cint; isoutput: cint; pin: cint; low32bits: cint; hi32bits: cint): bool {.cdecl.}
  proc TakeFX_SetPreset*(take: MediaItem_Take; fx: cint; presetname: cstring): bool {.cdecl.}
  proc TakeFX_SetPresetByIndex*(take: MediaItem_Take; fx: cint; idx: cint): bool {.cdecl.}
  proc TakeFX_Show*(take: MediaItem_Take; index: cint; showFlag: cint) {.cdecl.}
  proc TakeIsMIDI*(take: MediaItem_Take): bool {.cdecl.}
  proc ThemeLayout_GetLayout*(section: cstring; idx: cint; nameOut: cstring; nameOut_sz: cint): bool {.cdecl.}
  proc ThemeLayout_GetParameter*(wp: cint; descOutOptional: cstringArray; valueOutOptional: ptr cint; defValueOutOptional: ptr cint; minValueOutOptional: ptr cint; maxValueOutOptional: ptr cint): cstring {.cdecl.}
  proc ThemeLayout_RefreshAll*() {.cdecl.}
  proc ThemeLayout_SetLayout*(section: cstring; layout: cstring): bool {.cdecl.}
  proc ThemeLayout_SetParameter*(wp: cint; value: cint; persist: bool): bool {.cdecl.}
  proc time_precise*(): cdouble {.cdecl.}
  proc TimeMap2_beatsToTime*(proj: ReaProject; tpos: cdouble; measuresInOptional: ptr cint): cdouble {.cdecl.}
  proc TimeMap2_GetDividedBpmAtTime*(proj: ReaProject; time: cdouble): cdouble {.cdecl.}
  proc TimeMap2_GetNextChangeTime*(proj: ReaProject; time: cdouble): cdouble {.cdecl.}
  proc TimeMap2_QNToTime*(proj: ReaProject; qn: cdouble): cdouble {.cdecl.}
  proc TimeMap2_timeToBeats*(proj: ReaProject; tpos: cdouble; measuresOutOptional: ptr cint; cmlOutOptional: ptr cint; fullbeatsOutOptional: ptr cdouble; cdenomOutOptional: ptr cint): cdouble {.cdecl.}
  proc TimeMap2_timeToQN*(proj: ReaProject; tpos: cdouble): cdouble {.cdecl.}
  proc TimeMap_curFrameRate*(proj: ReaProject; dropFrameOutOptional: ptr bool): cdouble {.cdecl.}
  proc TimeMap_GetDividedBpmAtTime*(time: cdouble): cdouble {.cdecl.}
  proc TimeMap_GetMeasureInfo*(proj: ReaProject; measure: cint; qn_startOut: ptr cdouble; qn_endOut: ptr cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; tempoOut: ptr cdouble): cdouble {.cdecl.}
  proc TimeMap_GetMetronomePattern*(proj: ReaProject; time: cdouble; pattern: cstring; pattern_sz: cint): cint {.cdecl.}
  proc TimeMap_GetTimeSigAtTime*(proj: ReaProject; time: cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; tempoOut: ptr cdouble) {.cdecl.}
  proc TimeMap_QNToMeasures*(proj: ReaProject; qn: cdouble; qnMeasureStartOutOptional: ptr cdouble; qnMeasureEndOutOptional: ptr cdouble): cint {.cdecl.}
  proc TimeMap_QNToTime*(qn: cdouble): cdouble {.cdecl.}
  proc TimeMap_QNToTime_abs*(proj: ReaProject; qn: cdouble): cdouble {.cdecl.}
  proc TimeMap_timeToQN*(tpos: cdouble): cdouble {.cdecl.}
  proc TimeMap_timeToQN_abs*(proj: ReaProject; tpos: cdouble): cdouble {.cdecl.}
  proc ToggleTrackSendUIMute*(track: MediaTrack; send_idx: cint): bool {.cdecl.}
  proc Track_GetPeakHoldDB*(track: MediaTrack; channel: cint; clear: bool): cdouble {.cdecl.}
  proc Track_GetPeakInfo*(track: MediaTrack; channel: cint): cdouble {.cdecl.}
  proc TrackCtl_SetToolTip*(fmt: cstring; xpos: cint; ypos: cint; topmost: bool) {.cdecl.}
  proc TrackFX_AddByName*(track: MediaTrack; fxname: cstring; recFX: bool; instantiate: cint): cint {.cdecl.}
  proc TrackFX_CopyToTake*(src_track: MediaTrack; src_fx: cint; dest_take: MediaItem_Take; dest_fx: cint; is_move: bool) {.cdecl.}
  proc TrackFX_CopyToTrack*(src_track: MediaTrack; src_fx: cint; dest_track: MediaTrack; dest_fx: cint; is_move: bool) {.cdecl.}
  proc TrackFX_Delete*(track: MediaTrack; fx: cint): bool {.cdecl.}
  proc TrackFX_EndParamEdit*(track: MediaTrack; fx: cint; param: cint): bool {.cdecl.}
  proc TrackFX_FormatParamValue*(track: MediaTrack; fx: cint; param: cint; val: cdouble; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TrackFX_FormatParamValueNormalized*(track: MediaTrack; fx: cint; param: cint; value: cdouble; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TrackFX_GetByName*(track: MediaTrack; fxname: cstring; instantiate: bool): cint {.cdecl.}
  proc TrackFX_GetChainVisible*(track: MediaTrack): cint {.cdecl.}
  proc TrackFX_GetCount*(track: MediaTrack): cint {.cdecl.}
  proc TrackFX_GetEnabled*(track: MediaTrack; fx: cint): bool {.cdecl.}
  proc TrackFX_GetEQ*(track: MediaTrack; instantiate: bool): cint {.cdecl.}
  proc TrackFX_GetEQBandEnabled*(track: MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint): bool {.cdecl.}
  proc TrackFX_GetEQParam*(track: MediaTrack; fxidx: cint; paramidx: cint; bandtypeOut: ptr cint; bandidxOut: ptr cint; paramtypeOut: ptr cint; normvalOut: ptr cdouble): bool {.cdecl.}
  proc TrackFX_GetFloatingWindow*(track: MediaTrack; index: cint): HWND {.cdecl.}
  proc TrackFX_GetFormattedParamValue*(track: MediaTrack; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TrackFX_GetFXGUID*(track: MediaTrack; fx: cint): ptr GUID {.cdecl.}
  proc TrackFX_GetFXName*(track: MediaTrack; fx: cint; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TrackFX_GetInstrument*(track: MediaTrack): cint {.cdecl.}
  proc TrackFX_GetIOSize*(track: MediaTrack; fx: cint; inputPinsOutOptional: ptr cint; outputPinsOutOptional: ptr cint): cint {.cdecl.}
  proc TrackFX_GetNamedConfigParm*(track: MediaTrack; fx: cint; parmname: cstring; bufOut: cstring; bufOut_sz: cint): bool {.cdecl.}
  proc TrackFX_GetNumParams*(track: MediaTrack; fx: cint): cint {.cdecl.}
  proc TrackFX_GetOffline*(track: MediaTrack; fx: cint): bool {.cdecl.}
  proc TrackFX_GetOpen*(track: MediaTrack; fx: cint): bool {.cdecl.}
  proc TrackFX_GetParam*(track: MediaTrack; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble): cdouble {.cdecl.}
  proc TrackFX_GetParameterStepSizes*(track: MediaTrack; fx: cint; param: cint; stepOut: ptr cdouble; smallstepOut: ptr cdouble; largestepOut: ptr cdouble; istoggleOut: ptr bool): bool {.cdecl.}
  proc TrackFX_GetParamEx*(track: MediaTrack; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble; midvalOut: ptr cdouble): cdouble {.cdecl.}
  proc TrackFX_GetParamName*(track: MediaTrack; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool {.cdecl.}
  proc TrackFX_GetParamNormalized*(track: MediaTrack; fx: cint; param: cint): cdouble {.cdecl.}
  proc TrackFX_GetPinMappings*(tr: MediaTrack; fx: cint; isoutput: cint; pin: cint; high32OutOptional: ptr cint): cint {.cdecl.}
  proc TrackFX_GetPreset*(track: MediaTrack; fx: cint; presetname: cstring; presetname_sz: cint): bool {.cdecl.}
  proc TrackFX_GetPresetIndex*(track: MediaTrack; fx: cint; numberOfPresetsOut: ptr cint): cint {.cdecl.}
  proc TrackFX_GetRecChainVisible*(track: MediaTrack): cint {.cdecl.}
  proc TrackFX_GetRecCount*(track: MediaTrack): cint {.cdecl.}
  proc TrackFX_GetUserPresetFilename*(track: MediaTrack; fx: cint; fn: cstring; fn_sz: cint) {.cdecl.}
  proc TrackFX_NavigatePresets*(track: MediaTrack; fx: cint; presetmove: cint): bool {.cdecl.}
  proc TrackFX_SetEnabled*(track: MediaTrack; fx: cint; enabled: bool) {.cdecl.}
  proc TrackFX_SetEQBandEnabled*(track: MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint; enable: bool): bool {.cdecl.}
  proc TrackFX_SetEQParam*(track: MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint; paramtype: cint; val: cdouble; isnorm: bool): bool {.cdecl.}
  proc TrackFX_SetNamedConfigParm*(track: MediaTrack; fx: cint; parmname: cstring; value: cstring): bool {.cdecl.}
  proc TrackFX_SetOffline*(track: MediaTrack; fx: cint; offline: bool) {.cdecl.}
  proc TrackFX_SetOpen*(track: MediaTrack; fx: cint; open: bool) {.cdecl.}
  proc TrackFX_SetParam*(track: MediaTrack; fx: cint; param: cint; val: cdouble): bool {.cdecl.}
  proc TrackFX_SetParamNormalized*(track: MediaTrack; fx: cint; param: cint; value: cdouble): bool {.cdecl.}
  proc TrackFX_SetPinMappings*(tr: MediaTrack; fx: cint; isoutput: cint; pin: cint; low32bits: cint; hi32bits: cint): bool {.cdecl.}
  proc TrackFX_SetPreset*(track: MediaTrack; fx: cint; presetname: cstring): bool {.cdecl.}
  proc TrackFX_SetPresetByIndex*(track: MediaTrack; fx: cint; idx: cint): bool {.cdecl.}
  proc TrackFX_Show*(track: MediaTrack; index: cint; showFlag: cint) {.cdecl.}
  proc TrackList_AdjustWindows*(isMinor: bool) {.cdecl.}
  proc TrackList_UpdateAllExternalSurfaces*() {.cdecl.}
  proc Undo_BeginBlock*() {.cdecl.}
  proc Undo_BeginBlock2*(proj: ReaProject) {.cdecl.}
  proc Undo_CanRedo2*(proj: ReaProject): cstring {.cdecl.}
  proc Undo_CanUndo2*(proj: ReaProject): cstring {.cdecl.}
  proc Undo_DoRedo2*(proj: ReaProject): cint {.cdecl.}
  proc Undo_DoUndo2*(proj: ReaProject): cint {.cdecl.}
  proc Undo_EndBlock*(descchange: cstring; extraflags: cint) {.cdecl.}
  proc Undo_EndBlock2*(proj: ReaProject; descchange: cstring; extraflags: cint) {.cdecl.}
  proc Undo_OnStateChange*(descchange: cstring) {.cdecl.}
  proc Undo_OnStateChange2*(proj: ReaProject; descchange: cstring) {.cdecl.}
  proc Undo_OnStateChange_Item*(proj: ReaProject; name: cstring; item: MediaItem) {.cdecl.}
  proc Undo_OnStateChangeEx*(descchange: cstring; whichStates: cint; trackparm: cint) {.cdecl.}
  proc Undo_OnStateChangeEx2*(proj: ReaProject; descchange: cstring; whichStates: cint; trackparm: cint) {.cdecl.}
  proc update_disk_counters*(readamt: cint; writeamt: cint) {.cdecl.}
  proc UpdateArrange*() {.cdecl.}
  proc UpdateItemInProject*(item: MediaItem) {.cdecl.}
  proc UpdateTimeline*() {.cdecl.}
  proc ValidatePtr*(`pointer`: pointer; ctypename: cstring): bool {.cdecl.}
  proc ValidatePtr2*(proj: ReaProject; `pointer`: pointer; ctypename: cstring): bool {.cdecl.}
  proc ViewPrefs*(page: cint; pageByName: cstring) {.cdecl.}
  # proc WDL_VirtualWnd_ScaledBlitBG*(dest: LICE_IBitmap; src: ptr WDL_VirtualWnd_BGCfg; destx: cint; desty: cint; destw: cint; desth: cint; clipx: cint; clipy: cint; clipw: cint; cliph: cint; alpha: cfloat; mode: cint): bool {.cdecl.}