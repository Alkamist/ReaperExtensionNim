import std/macros
import ./types

# This macro allows you to pass in a list of nim
# function signatures for the reaper API.
#
# It will take each of those signatures and then generate
# a corresponding public global variable that is uninitialized.
#
# It will also generate a public function called loadApi that
# takes in a pointer to reaper_plugin_info_t as an argument.
#
# That function will then load the reaper api function pointers
# and assign them to the global variables.
#
#
# defineApi:
#   proc ShowConsoleMsg(msg: cstring)
#
#
# Would generate the following:
#
# var ShowConsoleMsg*: proc(msg: cstring) {.cdecl.}
#
# proc loadApi*(pluginInfo: ptr reaper_plugin_info_t) =
#   ShowConsoleMsg = cast[typeof(ShowConsoleMsg)](pluginInfo.GetFunc("ShowConsoleMsg"))

macro defineApi(functionSignatures) =
  let pluginInfo = newIdentNode("pluginInfo")

  var functionPointerDefinitions = nnkStmtList.newTree()
  var functionPointerAssignments = nnkStmtList.newTree()

  for signature in functionSignatures:
    let name = signature[0]
    let params = signature[3]

    functionPointerDefinitions.add nnkStmtList.newTree(
      nnkVarSection.newTree(
        nnkIdentDefs.newTree(
          nnkPostfix.newTree(
            newIdentNode("*"),
            name,
          ),
          nnkProcTy.newTree(
            params,
            nnkPragma.newTree(
              newIdentNode("cdecl")
            )
          ),
          newEmptyNode()
        )
      )
    )

    functionPointerAssignments.add nnkStmtList.newTree(
      nnkAsgn.newTree(
        name,
        nnkCast.newTree(
          nnkCall.newTree(
            newIdentNode("typeof"),
            name,
          ),
          nnkCall.newTree(
            nnkDotExpr.newTree(
              pluginInfo,
              newIdentNode("GetFunc"),
            ),
            newLit(name.strVal),
          ),
        ),
      ),
    )

  var loadApi = nnkStmtList.newTree(
    nnkProcDef.newTree(
      nnkPostfix.newTree(
        newIdentNode("*"),
        newIdentNode("loadApi")
      ),
      newEmptyNode(),
      newEmptyNode(),
      nnkFormalParams.newTree(
        newEmptyNode(),
        nnkIdentDefs.newTree(
          pluginInfo,
          nnkPtrTy.newTree(
            newIdentNode("reaper_plugin_info_t")
          ),
          newEmptyNode()
        )
      ),
      newEmptyNode(),
      newEmptyNode(),
      nnkStmtList.newTree(
        functionPointerAssignments,
      )
    )
  )

  result = nnkStmtList.newTree(
    functionPointerDefinitions,
    loadApi,
  )

defineApi:
  proc AddCustomizableMenu(menuidstr: cstring; menuname: cstring; kbdsecname: cstring; addtomainmenu: bool): bool
  proc AddExtensionsMainMenu(): bool
  proc AddMediaItemToTrack(tr: MediaTrack): MediaItem
  proc AddProjectMarker(proj: ReaProject; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; wantidx: cint): cint
  proc AddProjectMarker2(proj: ReaProject; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; wantidx: cint; color: cint): cint
  proc AddRemoveReaScript(add: bool; sectionID: cint; scriptfn: cstring; commit: bool): cint
  proc AddTakeToMediaItem(item: MediaItem): MediaItem_Take
  proc AddTempoTimeSigMarker(proj: ReaProject; timepos: cdouble; bpm: cdouble; timesig_num: cint; timesig_denom: cint; lineartempochange: bool): bool
  proc adjustZoom(amt: cdouble; forceset: cint; doupd: bool; centermode: cint)
  proc AnyTrackSolo(proj: ReaProject): bool
  proc APIExists(function_name: cstring): bool
  proc APITest()
  proc ApplyNudge(project: ReaProject; nudgeflag: cint; nudgewhat: cint; nudgeunits: cint; value: cdouble; reverse: bool; copies: cint): bool
  proc ArmCommand(cmd: cint; sectionname: cstring)
  proc Audio_Init()
  proc Audio_IsPreBuffer(): cint
  proc Audio_IsRunning(): cint
  proc Audio_Quit()
  # proc Audio_RegHardwareHook(isAdd: bool; reg: ptr audio_hook_register_t): cint
  # proc AudioAccessorStateChanged(accessor: AudioAccessor): bool
  # proc AudioAccessorUpdate(accessor: AudioAccessor)
  # proc AudioAccessorValidateState(accessor: AudioAccessor): bool
  proc BypassFxAllTracks(bypass: cint)
  # proc CalculatePeaks(srcBlock: ptr PCM_source_transfer_t; pksBlock: ptr PCM_source_peaktransfer_t): cint
  # proc CalculatePeaksFloatSrcPtr(srcBlock: ptr PCM_source_transfer_t; pksBlock: ptr PCM_source_peaktransfer_t): cint
  proc ClearAllRecArmed()
  proc ClearConsole()
  proc ClearPeakCache()
  proc ColorFromNative(col: cint; rOut: ptr cint; gOut: ptr cint; bOut: ptr cint)
  proc ColorToNative(r: cint; g: cint; b: cint): cint
  proc CountActionShortcuts(section: ptr KbdSectionInfo; cmdID: cint): cint
  proc CountAutomationItems(env: TrackEnvelope): cint
  proc CountEnvelopePoints(envelope: TrackEnvelope): cint
  proc CountEnvelopePointsEx(envelope: TrackEnvelope; autoitem_idx: cint): cint
  proc CountMediaItems(proj: ReaProject): cint
  proc CountProjectMarkers(proj: ReaProject; num_markersOut: ptr cint; num_regionsOut: ptr cint): cint
  proc CountSelectedMediaItems(proj: ReaProject): cint
  proc CountSelectedTracks(proj: ReaProject): cint
  proc CountSelectedTracks2(proj: ReaProject; wantmaster: bool): cint
  proc CountTakeEnvelopes(take: MediaItem_Take): cint
  proc CountTakes(item: MediaItem): cint
  proc CountTCPFXParms(project: ReaProject; track: MediaTrack): cint
  proc CountTempoTimeSigMarkers(proj: ReaProject): cint
  proc CountTrackEnvelopes(track: MediaTrack): cint
  proc CountTrackMediaItems(track: MediaTrack): cint
  proc CountTracks(projOptional: ReaProject): cint
  proc CreateLocalOscHandler(obj: pointer; callback: pointer): pointer
  # proc CreateMIDIInput(dev: cint): ptr midi_Input
  # proc CreateMIDIOutput(dev: cint; streamMode: bool; msoffset100: ptr cint): ptr midi_Output
  proc CreateNewMIDIItemInProj(track: MediaTrack; starttime: cdouble; endtime: cdouble; qnInOptional: ptr bool): MediaItem
  proc CreateTakeAudioAccessor(take: MediaItem_Take): AudioAccessor
  proc CreateTrackAudioAccessor(track: MediaTrack): AudioAccessor
  proc CreateTrackSend(tr: MediaTrack; desttrInOptional: MediaTrack): cint
  proc CSurf_FlushUndo(force: bool)
  proc CSurf_GetTouchState(trackid: MediaTrack; isPan: cint): bool
  proc CSurf_GoEnd()
  proc CSurf_GoStart()
  proc CSurf_NumTracks(mcpView: bool): cint
  proc CSurf_OnArrow(whichdir: cint; wantzoom: bool)
  proc CSurf_OnFwd(seekplay: cint)
  proc CSurf_OnFXChange(trackid: MediaTrack; en: cint): bool
  proc CSurf_OnInputMonitorChange(trackid: MediaTrack; monitor: cint): cint
  proc CSurf_OnInputMonitorChangeEx(trackid: MediaTrack; monitor: cint; allowgang: bool): cint
  proc CSurf_OnMuteChange(trackid: MediaTrack; mute: cint): bool
  proc CSurf_OnMuteChangeEx(trackid: MediaTrack; mute: cint; allowgang: bool): bool
  proc CSurf_OnOscControlMessage(msg: cstring; arg: ptr cfloat)
  proc CSurf_OnPanChange(trackid: MediaTrack; pan: cdouble; relative: bool): cdouble
  proc CSurf_OnPanChangeEx(trackid: MediaTrack; pan: cdouble; relative: bool; allowGang: bool): cdouble
  proc CSurf_OnPause()
  proc CSurf_OnPlay()
  proc CSurf_OnPlayRateChange(playrate: cdouble)
  proc CSurf_OnRecArmChange(trackid: MediaTrack; recarm: cint): bool
  proc CSurf_OnRecArmChangeEx(trackid: MediaTrack; recarm: cint; allowgang: bool): bool
  proc CSurf_OnRecord()
  proc CSurf_OnRecvPanChange(trackid: MediaTrack; recv_index: cint; pan: cdouble; relative: bool): cdouble
  proc CSurf_OnRecvVolumeChange(trackid: MediaTrack; recv_index: cint; volume: cdouble; relative: bool): cdouble
  proc CSurf_OnRew(seekplay: cint)
  proc CSurf_OnRewFwd(seekplay: cint; dir: cint)
  proc CSurf_OnScroll(xdir: cint; ydir: cint)
  proc CSurf_OnSelectedChange(trackid: MediaTrack; selected: cint): bool
  proc CSurf_OnSendPanChange(trackid: MediaTrack; send_index: cint; pan: cdouble; relative: bool): cdouble
  proc CSurf_OnSendVolumeChange(trackid: MediaTrack; send_index: cint; volume: cdouble; relative: bool): cdouble
  proc CSurf_OnSoloChange(trackid: MediaTrack; solo: cint): bool
  proc CSurf_OnSoloChangeEx(trackid: MediaTrack; solo: cint; allowgang: bool): bool
  proc CSurf_OnStop()
  proc CSurf_OnTempoChange(bpm: cdouble)
  proc CSurf_OnTrackSelection(trackid: MediaTrack)
  proc CSurf_OnVolumeChange(trackid: MediaTrack; volume: cdouble; relative: bool): cdouble
  proc CSurf_OnVolumeChangeEx(trackid: MediaTrack; volume: cdouble; relative: bool; allowGang: bool): cdouble
  proc CSurf_OnWidthChange(trackid: MediaTrack; width: cdouble; relative: bool): cdouble
  proc CSurf_OnWidthChangeEx(trackid: MediaTrack; width: cdouble; relative: bool; allowGang: bool): cdouble
  proc CSurf_OnZoom(xdir: cint; ydir: cint)
  proc CSurf_ResetAllCachedVolPanStates()
  proc CSurf_ScrubAmt(amt: cdouble)
  # proc CSurf_SetAutoMode(mode: cint; ignoresurf: ptr IReaperControlSurface)
  # proc CSurf_SetPlayState(play: bool; pause: bool; rec: bool; ignoresurf: ptr IReaperControlSurface)
  # proc CSurf_SetRepeatState(rep: bool; ignoresurf: ptr IReaperControlSurface)
  # proc CSurf_SetSurfaceMute(trackid: MediaTrack; mute: bool; ignoresurf: ptr IReaperControlSurface)
  # proc CSurf_SetSurfacePan(trackid: MediaTrack; pan: cdouble; ignoresurf: ptr IReaperControlSurface)
  # proc CSurf_SetSurfaceRecArm(trackid: MediaTrack; recarm: bool; ignoresurf: ptr IReaperControlSurface)
  # proc CSurf_SetSurfaceSelected(trackid: MediaTrack; selected: bool; ignoresurf: ptr IReaperControlSurface)
  # proc CSurf_SetSurfaceSolo(trackid: MediaTrack; solo: bool; ignoresurf: ptr IReaperControlSurface)
  # proc CSurf_SetSurfaceVolume(trackid: MediaTrack; volume: cdouble; ignoresurf: ptr IReaperControlSurface)
  proc CSurf_SetTrackListChange()
  proc CSurf_TrackFromID(idx: cint; mcpView: bool): MediaTrack
  proc CSurf_TrackToID(track: MediaTrack; mcpView: bool): cint
  proc DB2SLIDER(x: cdouble): cdouble
  proc DeleteActionShortcut(section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint): bool
  proc DeleteEnvelopePointEx(envelope: TrackEnvelope; autoitem_idx: cint; ptidx: cint): bool
  proc DeleteEnvelopePointRange(envelope: TrackEnvelope; time_start: cdouble; time_end: cdouble): bool
  proc DeleteEnvelopePointRangeEx(envelope: TrackEnvelope; autoitem_idx: cint; time_start: cdouble; time_end: cdouble): bool
  proc DeleteExtState(section: cstring; key: cstring; persist: bool)
  proc DeleteProjectMarker(proj: ReaProject; markrgnindexnumber: cint; isrgn: bool): bool
  proc DeleteProjectMarkerByIndex(proj: ReaProject; markrgnidx: cint): bool
  proc DeleteTakeMarker(take: MediaItem_Take; idx: cint): bool
  proc DeleteTakeStretchMarkers(take: MediaItem_Take; idx: cint; countInOptional: ptr cint): cint
  proc DeleteTempoTimeSigMarker(project: ReaProject; markerindex: cint): bool
  proc DeleteTrack(tr: MediaTrack)
  proc DeleteTrackMediaItem(tr: MediaTrack; it: MediaItem): bool
  proc DestroyAudioAccessor(accessor: AudioAccessor)
  proc DestroyLocalOscHandler(local_osc_handler: pointer)
  proc DoActionShortcutDialog(hwnd: HWND; section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint): bool
  proc Dock_UpdateDockID(ident_str: cstring; whichDock: cint)
  proc DockGetPosition(whichDock: cint): cint
  proc DockIsChildOfDock(hwnd: HWND; isFloatingDockerOut: ptr bool): cint
  proc DockWindowActivate(hwnd: HWND)
  proc DockWindowAdd(hwnd: HWND; name: cstring; pos: cint; allowShow: bool)
  proc DockWindowAddEx(hwnd: HWND; name: cstring; identstr: cstring; allowShow: bool)
  proc DockWindowRefresh()
  proc DockWindowRefreshForHWND(hwnd: HWND)
  proc DockWindowRemove(hwnd: HWND)
  proc DuplicateCustomizableMenu(srcmenu: pointer; destmenu: pointer): bool
  proc EditTempoTimeSigMarker(project: ReaProject; markerindex: cint): bool
  proc EnsureNotCompletelyOffscreen(rInOut: ptr RECT)
  proc EnumerateFiles(path: cstring; fileindex: cint): cstring
  proc EnumerateSubdirectories(path: cstring; subdirindex: cint): cstring
  proc EnumPitchShiftModes(mode: cint; strOut: cstringArray): bool
  proc EnumPitchShiftSubModes(mode: cint; submode: cint): cstring
  proc EnumProjectMarkers(idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint): cint
  proc EnumProjectMarkers2(proj: ReaProject; idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint): cint
  proc EnumProjectMarkers3(proj: ReaProject; idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint; colorOut: ptr cint): cint
  proc EnumProjects(idx: cint; projfnOutOptional: cstring; projfnOutOptional_sz: cint): ReaProject
  proc EnumProjExtState(proj: ReaProject; extname: cstring; idx: cint; keyOutOptional: cstring; keyOutOptional_sz: cint; valOutOptional: cstring; valOutOptional_sz: cint): bool
  proc EnumRegionRenderMatrix(proj: ReaProject; regionindex: cint; rendertrack: cint): MediaTrack
  proc EnumTrackMIDIProgramNames(track: cint; programNumber: cint; programName: cstring; programName_sz: cint): bool
  proc EnumTrackMIDIProgramNamesEx(proj: ReaProject; track: MediaTrack; programNumber: cint; programName: cstring; programName_sz: cint): bool
  proc Envelope_Evaluate(envelope: TrackEnvelope; time: cdouble; samplerate: cdouble; samplesRequested: cint; valueOutOptional: ptr cdouble; dVdSOutOptional: ptr cdouble; ddVdSOutOptional: ptr cdouble; dddVdSOutOptional: ptr cdouble): cint
  proc Envelope_FormatValue(env: TrackEnvelope; value: cdouble; bufOut: cstring; bufOut_sz: cint)
  proc Envelope_GetParentTake(env: TrackEnvelope; indexOutOptional: ptr cint; index2OutOptional: ptr cint): MediaItem_Take
  proc Envelope_GetParentTrack(env: TrackEnvelope; indexOutOptional: ptr cint; index2OutOptional: ptr cint): MediaTrack
  proc Envelope_SortPoints(envelope: TrackEnvelope): bool
  proc Envelope_SortPointsEx(envelope: TrackEnvelope; autoitem_idx: cint): bool
  proc ExecProcess(cmdline: cstring; timeoutmsec: cint): cstring
  proc file_exists(path: cstring): bool
  proc FindTempoTimeSigMarker(project: ReaProject; time: cdouble): cint
  proc format_timestr(tpos: cdouble; buf: cstring; buf_sz: cint)
  proc format_timestr_len(tpos: cdouble; buf: cstring; buf_sz: cint; offset: cdouble; modeoverride: cint)
  proc format_timestr_pos(tpos: cdouble; buf: cstring; buf_sz: cint; modeoverride: cint)
  proc FreeHeapPtr(`ptr`: pointer)
  proc genGuid(g: ptr GUID)
  proc get_config_var(name: cstring; szOut: ptr cint): pointer
  proc get_config_var_string(name: cstring; bufOut: cstring; bufOut_sz: cint): bool
  proc get_ini_file(): cstring
  proc get_midi_config_var(name: cstring; szOut: ptr cint): pointer
  proc GetActionShortcutDesc(section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint; desc: cstring; desclen: cint): bool
  proc GetActiveTake(item: MediaItem): MediaItem_Take
  proc GetAllProjectPlayStates(ignoreProject: ReaProject): cint
  proc GetAppVersion(): cstring
  proc GetArmedCommand(secOut: cstring; secOut_sz: cint): cint
  proc GetAudioAccessorEndTime(accessor: AudioAccessor): cdouble
  proc GetAudioAccessorHash(accessor: AudioAccessor; hashNeed128: cstring)
  proc GetAudioAccessorSamples(accessor: AudioAccessor; samplerate: cint; numchannels: cint; starttime_sec: cdouble; numsamplesperchannel: cint; samplebuffer: ptr cdouble): cint
  proc GetAudioAccessorStartTime(accessor: AudioAccessor): cdouble
  proc GetAudioDeviceInfo(attribute: cstring; desc: cstring; desc_sz: cint): bool
  proc GetColorTheme(idx: cint; defval: cint): INT_PTR
  proc GetColorThemeStruct(szOut: ptr cint): pointer
  proc GetConfigWantsDock(ident_str: cstring): cint
  proc GetContextMenu(idx: cint): HMENU
  proc GetCurrentProjectInLoadSave(): ReaProject
  proc GetCursorContext(): cint
  proc GetCursorContext2(want_last_valid: bool): cint
  proc GetCursorPosition(): cdouble
  proc GetCursorPositionEx(proj: ReaProject): cdouble
  proc GetDisplayedMediaItemColor(item: MediaItem): cint
  proc GetDisplayedMediaItemColor2(item: MediaItem; take: MediaItem_Take): cint
  proc GetEnvelopeInfo_Value(tr: TrackEnvelope; parmname: cstring): cdouble
  proc GetEnvelopeName(env: TrackEnvelope; bufOut: cstring; bufOut_sz: cint): bool
  proc GetEnvelopePoint(envelope: TrackEnvelope; ptidx: cint; timeOutOptional: ptr cdouble; valueOutOptional: ptr cdouble; shapeOutOptional: ptr cint; tensionOutOptional: ptr cdouble; selectedOutOptional: ptr bool): bool
  proc GetEnvelopePointByTime(envelope: TrackEnvelope; time: cdouble): cint
  proc GetEnvelopePointByTimeEx(envelope: TrackEnvelope; autoitem_idx: cint; time: cdouble): cint
  proc GetEnvelopePointEx(envelope: TrackEnvelope; autoitem_idx: cint; ptidx: cint; timeOutOptional: ptr cdouble; valueOutOptional: ptr cdouble; shapeOutOptional: ptr cint; tensionOutOptional: ptr cdouble; selectedOutOptional: ptr bool): bool
  proc GetEnvelopeScalingMode(env: TrackEnvelope): cint
  proc GetEnvelopeStateChunk(env: TrackEnvelope; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool
  proc GetExePath(): cstring
  proc GetExtState(section: cstring; key: cstring): cstring
  proc GetFocusedFX(tracknumberOut: ptr cint; itemnumberOut: ptr cint; fxnumberOut: ptr cint): cint
  proc GetFocusedFX2(tracknumberOut: ptr cint; itemnumberOut: ptr cint; fxnumberOut: ptr cint): cint
  proc GetFreeDiskSpaceForRecordPath(proj: ReaProject; pathidx: cint): cint
  proc GetFXEnvelope(track: MediaTrack; fxindex: cint; parameterindex: cint; create: bool): TrackEnvelope
  proc GetGlobalAutomationOverride(): cint
  proc GetHZoomLevel(): cdouble
  proc GetIconThemePointer(name: cstring): pointer
  proc GetIconThemePointerForDPI(name: cstring; dpisc: cint): pointer
  proc GetIconThemeStruct(szOut: ptr cint): pointer
  proc GetInputChannelName(channelIndex: cint): cstring
  proc GetInputOutputLatency(inputlatencyOut: ptr cint; outputLatencyOut: ptr cint)
  # proc GetItemEditingTime2(which_itemOut: PCM_source; flagsOut: ptr cint): cdouble
  proc GetItemFromPoint(screen_x: cint; screen_y: cint; allow_locked: bool; takeOutOptional: ptr MediaItem_Take): MediaItem
  proc GetItemProjectContext(item: MediaItem): ReaProject
  proc GetItemStateChunk(item: MediaItem; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool
  proc GetLastColorThemeFile(): cstring
  proc GetLastMarkerAndCurRegion(proj: ReaProject; time: cdouble; markeridxOut: ptr cint; regionidxOut: ptr cint)
  proc GetLastTouchedFX(tracknumberOut: ptr cint; fxnumberOut: ptr cint; paramnumberOut: ptr cint): bool
  proc GetLastTouchedTrack(): MediaTrack
  proc GetMainHwnd(): HWND
  proc GetMasterMuteSoloFlags(): cint
  proc GetMasterTrack(proj: ReaProject): MediaTrack
  proc GetMasterTrackVisibility(): cint
  proc GetMaxMidiInputs(): cint
  proc GetMaxMidiOutputs(): cint
  proc GetMediaFileMetadata(mediaSource: PCM_source; identifier: cstring; bufOutNeedBig: cstring; bufOutNeedBig_sz: cint): cint
  proc GetMediaItem(proj: ReaProject; itemidx: cint): MediaItem
  proc GetMediaItemInfo_Value(item: MediaItem; parmname: cstring): cdouble
  proc GetMediaItemNumTakes(item: MediaItem): cint
  proc GetMediaItemTake(item: MediaItem; tk: cint): MediaItem_Take
  proc GetMediaItemTake_Item(take: MediaItem_Take): MediaItem
  proc GetMediaItemTake_Peaks(take: MediaItem_Take; peakrate: cdouble; starttime: cdouble; numchannels: cint; numsamplesperchannel: cint; want_extra_type: cint; buf: ptr cdouble): cint
  proc GetMediaItemTake_Source(take: MediaItem_Take): PCM_source
  proc GetMediaItemTake_Track(take: MediaItem_Take): MediaTrack
  proc GetMediaItemTakeByGUID(project: ReaProject; guid: ptr GUID): MediaItem_Take
  proc GetMediaItemTakeInfo_Value(take: MediaItem_Take; parmname: cstring): cdouble
  proc GetMediaItemTrack(item: MediaItem): MediaTrack
  proc GetMediaSourceFileName(source: PCM_source; filenamebuf: cstring; filenamebuf_sz: cint)
  proc GetMediaSourceLength(source: PCM_source; lengthIsQNOut: ptr bool): cdouble
  proc GetMediaSourceNumChannels(source: PCM_source): cint
  proc GetMediaSourceParent(src: PCM_source): PCM_source
  proc GetMediaSourceSampleRate(source: PCM_source): cint
  proc GetMediaSourceType(source: PCM_source; typebuf: cstring; typebuf_sz: cint)
  proc GetMediaTrackInfo_Value(tr: MediaTrack; parmname: cstring): cdouble
  proc GetMIDIInputName(dev: cint; nameout: cstring; nameout_sz: cint): bool
  proc GetMIDIOutputName(dev: cint; nameout: cstring; nameout_sz: cint): bool
  proc GetMixerScroll(): MediaTrack
  proc GetMouseModifier(context: cstring; modifier_flag: cint; action: cstring; action_sz: cint)
  proc GetMousePosition(xOut: ptr cint; yOut: ptr cint)
  proc GetNumAudioInputs(): cint
  proc GetNumAudioOutputs(): cint
  proc GetNumMIDIInputs(): cint
  proc GetNumMIDIOutputs(): cint
  proc GetNumTakeMarkers(take: MediaItem_Take): cint
  proc GetNumTracks(): cint
  proc GetOS(): cstring
  proc GetOutputChannelName(channelIndex: cint): cstring
  proc GetOutputLatency(): cdouble
  proc GetParentTrack(track: MediaTrack): MediaTrack
  proc GetPeakFileName(fn: cstring; buf: cstring; buf_sz: cint)
  proc GetPeakFileNameEx(fn: cstring; buf: cstring; buf_sz: cint; forWrite: bool)
  proc GetPeakFileNameEx2(fn: cstring; buf: cstring; buf_sz: cint; forWrite: bool; peaksfileextension: cstring)
  # proc GetPeaksBitmap(pks: ptr PCM_source_peaktransfer_t; maxamp: cdouble; w: cint; h: cint; bmp: LICE_IBitmap): pointer
  proc GetPlayPosition(): cdouble
  proc GetPlayPosition2(): cdouble
  proc GetPlayPosition2Ex(proj: ReaProject): cdouble
  proc GetPlayPositionEx(proj: ReaProject): cdouble
  proc GetPlayState(): cint
  proc GetPlayStateEx(proj: ReaProject): cint
  proc GetPreferredDiskReadMode(mode: ptr cint; nb: ptr cint; bs: ptr cint)
  proc GetPreferredDiskReadModePeak(mode: ptr cint; nb: ptr cint; bs: ptr cint)
  proc GetPreferredDiskWriteMode(mode: ptr cint; nb: ptr cint; bs: ptr cint)
  proc GetProjectLength(proj: ReaProject): cdouble
  proc GetProjectName(proj: ReaProject; buf: cstring; buf_sz: cint)
  proc GetProjectPath(buf: cstring; buf_sz: cint)
  proc GetProjectPathEx(proj: ReaProject; buf: cstring; buf_sz: cint)
  proc GetProjectStateChangeCount(proj: ReaProject): cint
  proc GetProjectTimeOffset(proj: ReaProject; rndframe: bool): cdouble
  proc GetProjectTimeSignature(bpmOut: ptr cdouble; bpiOut: ptr cdouble)
  proc GetProjectTimeSignature2(proj: ReaProject; bpmOut: ptr cdouble; bpiOut: ptr cdouble)
  proc GetProjExtState(proj: ReaProject; extname: cstring; key: cstring; valOutNeedBig: cstring; valOutNeedBig_sz: cint): cint
  proc GetResourcePath(): cstring
  proc GetSelectedEnvelope(proj: ReaProject): TrackEnvelope
  proc GetSelectedMediaItem(proj: ReaProject; selitem: cint): MediaItem
  proc GetSelectedTrack(proj: ReaProject; seltrackidx: cint): MediaTrack
  proc GetSelectedTrack2(proj: ReaProject; seltrackidx: cint; wantmaster: bool): MediaTrack
  proc GetSelectedTrackEnvelope(proj: ReaProject): TrackEnvelope
  proc GetSet_ArrangeView2(proj: ReaProject; isSet: bool; screen_x_start: cint; screen_x_end: cint; start_timeOut: ptr cdouble; end_timeOut: ptr cdouble)
  proc GetSet_LoopTimeRange(isSet: bool; isLoop: bool; startOut: ptr cdouble; endOut: ptr cdouble; allowautoseek: bool)
  proc GetSet_LoopTimeRange2(proj: ReaProject; isSet: bool; isLoop: bool; startOut: ptr cdouble; endOut: ptr cdouble; allowautoseek: bool)
  proc GetSetAutomationItemInfo(env: TrackEnvelope; autoitem_idx: cint; desc: cstring; value: cdouble; is_set: bool): cdouble
  proc GetSetAutomationItemInfo_String(env: TrackEnvelope; autoitem_idx: cint; desc: cstring; valuestrNeedBig: cstring; is_set: bool): bool
  proc GetSetEnvelopeInfo_String(env: TrackEnvelope; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool
  proc GetSetEnvelopeState(env: TrackEnvelope; str: cstring; str_sz: cint): bool
  proc GetSetEnvelopeState2(env: TrackEnvelope; str: cstring; str_sz: cint; isundo: bool): bool
  proc GetSetItemState(item: MediaItem; str: cstring; str_sz: cint): bool
  proc GetSetItemState2(item: MediaItem; str: cstring; str_sz: cint; isundo: bool): bool
  proc GetSetMediaItemInfo(item: MediaItem; parmname: cstring; setNewValue: pointer): pointer
  proc GetSetMediaItemInfo_String(item: MediaItem; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool
  proc GetSetMediaItemTakeInfo(tk: MediaItem_Take; parmname: cstring; setNewValue: pointer): pointer
  proc GetSetMediaItemTakeInfo_String(tk: MediaItem_Take; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool
  proc GetSetMediaTrackInfo(tr: MediaTrack; parmname: cstring; setNewValue: pointer): pointer
  proc GetSetMediaTrackInfo_String(tr: MediaTrack; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool
  proc GetSetObjectState(obj: pointer; str: cstring): cstring
  proc GetSetObjectState2(obj: pointer; str: cstring; isundo: bool): cstring
  proc GetSetProjectAuthor(proj: ReaProject; set: bool; author: cstring; author_sz: cint)
  proc GetSetProjectGrid(project: ReaProject; set: bool; divisionInOutOptional: ptr cdouble; swingmodeInOutOptional: ptr cint; swingamtInOutOptional: ptr cdouble): cint
  proc GetSetProjectInfo(project: ReaProject; desc: cstring; value: cdouble; is_set: bool): cdouble
  proc GetSetProjectInfo_String(project: ReaProject; desc: cstring; valuestrNeedBig: cstring; is_set: bool): bool
  proc GetSetProjectNotes(proj: ReaProject; set: bool; notesNeedBig: cstring; notesNeedBig_sz: cint)
  proc GetSetRepeat(val: cint): cint
  proc GetSetRepeatEx(proj: ReaProject; val: cint): cint
  proc GetSetTrackGroupMembership(tr: MediaTrack; groupname: cstring; setmask: cuint; setvalue: cuint): cuint
  proc GetSetTrackGroupMembershipHigh(tr: MediaTrack; groupname: cstring; setmask: cuint; setvalue: cuint): cuint
  proc GetSetTrackMIDISupportFile(proj: ReaProject; track: MediaTrack; which: cint; filename: cstring): cstring
  proc GetSetTrackSendInfo(tr: MediaTrack; category: cint; sendidx: cint; parmname: cstring; setNewValue: pointer): pointer
  proc GetSetTrackSendInfo_String(tr: MediaTrack; category: cint; sendidx: cint; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool
  proc GetSetTrackState(track: MediaTrack; str: cstring; str_sz: cint): bool
  proc GetSetTrackState2(track: MediaTrack; str: cstring; str_sz: cint; isundo: bool): bool
  proc GetSubProjectFromSource(src: PCM_source): ReaProject
  proc GetTake(item: MediaItem; takeidx: cint): MediaItem_Take
  proc GetTakeEnvelope(take: MediaItem_Take; envidx: cint): TrackEnvelope
  proc GetTakeEnvelopeByName(take: MediaItem_Take; envname: cstring): TrackEnvelope
  proc GetTakeMarker(take: MediaItem_Take; idx: cint; nameOut: cstring; nameOut_sz: cint; colorOutOptional: ptr cint): cdouble
  proc GetTakeName(take: MediaItem_Take): cstring
  proc GetTakeNumStretchMarkers(take: MediaItem_Take): cint
  proc GetTakeStretchMarker(take: MediaItem_Take; idx: cint; posOut: ptr cdouble; srcposOutOptional: ptr cdouble): cint
  proc GetTakeStretchMarkerSlope(take: MediaItem_Take; idx: cint): cdouble
  proc GetTCPFXParm(project: ReaProject; track: MediaTrack; index: cint; fxindexOut: ptr cint; parmidxOut: ptr cint): bool
  proc GetTempoMatchPlayRate(source: PCM_source; srcscale: cdouble; position: cdouble; mult: cdouble; rateOut: ptr cdouble; targetlenOut: ptr cdouble): bool
  proc GetTempoTimeSigMarker(proj: ReaProject; ptidx: cint; timeposOut: ptr cdouble; measureposOut: ptr cint; beatposOut: ptr cdouble; bpmOut: ptr cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; lineartempoOut: ptr bool): bool
  proc GetThemeColor(ini_key: cstring; flagsOptional: cint): cint
  proc GetToggleCommandState(command_id: cint): cint
  proc GetToggleCommandState2(section: ptr KbdSectionInfo; command_id: cint): cint
  proc GetToggleCommandStateEx(section_id: cint; command_id: cint): cint
  proc GetToggleCommandStateThroughHooks(section: ptr KbdSectionInfo; command_id: cint): cint
  proc GetTooltipWindow(): HWND
  proc GetTrack(proj: ReaProject; trackidx: cint): MediaTrack
  proc GetTrackAutomationMode(tr: MediaTrack): cint
  proc GetTrackColor(track: MediaTrack): cint
  proc GetTrackDepth(track: MediaTrack): cint
  proc GetTrackEnvelope(track: MediaTrack; envidx: cint): TrackEnvelope
  proc GetTrackEnvelopeByChunkName(tr: MediaTrack; cfgchunkname: cstring): TrackEnvelope
  proc GetTrackEnvelopeByName(track: MediaTrack; envname: cstring): TrackEnvelope
  proc GetTrackFromPoint(screen_x: cint; screen_y: cint; infoOutOptional: ptr cint): MediaTrack
  proc GetTrackGUID(tr: MediaTrack): ptr GUID
  proc GetTrackInfo(track: INT_PTR; flags: ptr cint): cstring
  proc GetTrackMediaItem(tr: MediaTrack; itemidx: cint): MediaItem
  proc GetTrackMIDILyrics(track: MediaTrack; flag: cint; bufWantNeedBig: cstring; bufWantNeedBig_sz: ptr cint): bool
  proc GetTrackMIDINoteName(track: cint; pitch: cint; chan: cint): cstring
  proc GetTrackMIDINoteNameEx(proj: ReaProject; track: MediaTrack; pitch: cint; chan: cint): cstring
  proc GetTrackMIDINoteRange(proj: ReaProject; track: MediaTrack; note_loOut: ptr cint; note_hiOut: ptr cint)
  proc GetTrackName(track: MediaTrack; bufOut: cstring; bufOut_sz: cint): bool
  proc GetTrackNumMediaItems(tr: MediaTrack): cint
  proc GetTrackNumSends(tr: MediaTrack; category: cint): cint
  proc GetTrackReceiveName(track: MediaTrack; recv_index: cint; buf: cstring; buf_sz: cint): bool
  proc GetTrackReceiveUIMute(track: MediaTrack; recv_index: cint; muteOut: ptr bool): bool
  proc GetTrackReceiveUIVolPan(track: MediaTrack; recv_index: cint; volumeOut: ptr cdouble; panOut: ptr cdouble): bool
  proc GetTrackSendInfo_Value(tr: MediaTrack; category: cint; sendidx: cint; parmname: cstring): cdouble
  proc GetTrackSendName(track: MediaTrack; send_index: cint; buf: cstring; buf_sz: cint): bool
  proc GetTrackSendUIMute(track: MediaTrack; send_index: cint; muteOut: ptr bool): bool
  proc GetTrackSendUIVolPan(track: MediaTrack; send_index: cint; volumeOut: ptr cdouble; panOut: ptr cdouble): bool
  proc GetTrackState(track: MediaTrack; flagsOut: ptr cint): cstring
  proc GetTrackStateChunk(track: MediaTrack; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool
  proc GetTrackUIMute(track: MediaTrack; muteOut: ptr bool): bool
  proc GetTrackUIPan(track: MediaTrack; pan1Out: ptr cdouble; pan2Out: ptr cdouble; panmodeOut: ptr cint): bool
  proc GetTrackUIVolPan(track: MediaTrack; volumeOut: ptr cdouble; panOut: ptr cdouble): bool
  proc GetUnderrunTime(audio_xrunOutOptional: ptr cuint; media_xrunOutOptional: ptr cuint; curtimeOutOptional: ptr cuint)
  proc GetUserFileNameForRead(filenameNeed4096: cstring; title: cstring; defext: cstring): bool
  proc GetUserInputs(title: cstring; num_inputs: cint; captions_csv: cstring; retvals_csv: cstring; retvals_csv_sz: cint): bool
  proc GoToMarker(proj: ReaProject; marker_index: cint; use_timeline_order: bool)
  proc GoToRegion(proj: ReaProject; region_index: cint; use_timeline_order: bool)
  proc GR_SelectColor(hwnd: HWND; colorOut: ptr cint): cint
  proc GSC_mainwnd(t: cint): cint
  proc guidToString(g: ptr GUID; destNeed64: cstring)
  proc HasExtState(section: cstring; key: cstring): bool
  proc HasTrackMIDIPrograms(track: cint): cstring
  proc HasTrackMIDIProgramsEx(proj: ReaProject; track: MediaTrack): cstring
  proc Help_Set(helpstring: cstring; is_temporary_help: bool)
  # proc HiresPeaksFromSource(src: PCM_source; `block`: ptr PCM_source_peaktransfer_t)
  proc image_resolve_fn(`in`: cstring; `out`: cstring; out_sz: cint)
  proc InsertAutomationItem(env: TrackEnvelope; pool_id: cint; position: cdouble; length: cdouble): cint
  proc InsertEnvelopePoint(envelope: TrackEnvelope; time: cdouble; value: cdouble; shape: cint; tension: cdouble; selected: bool; noSortInOptional: ptr bool): bool
  proc InsertEnvelopePointEx(envelope: TrackEnvelope; autoitem_idx: cint; time: cdouble; value: cdouble; shape: cint; tension: cdouble; selected: bool; noSortInOptional: ptr bool): bool
  proc InsertMedia(file: cstring; mode: cint): cint
  proc InsertMediaSection(file: cstring; mode: cint; startpct: cdouble; endpct: cdouble; pitchshift: cdouble): cint
  proc InsertTrackAtIndex(idx: cint; wantDefaults: bool)
  proc IsInRealTimeAudio(): cint
  proc IsItemTakeActiveForPlayback(item: MediaItem; take: MediaItem_Take): bool
  proc IsMediaExtension(ext: cstring; wantOthers: bool): bool
  proc IsMediaItemSelected(item: MediaItem): bool
  proc IsProjectDirty(proj: ReaProject): cint
  proc IsREAPER(): bool
  proc IsTrackSelected(track: MediaTrack): bool
  proc IsTrackVisible(track: MediaTrack; mixer: bool): bool
  proc joystick_create(guid: ptr GUID): joystick_device
  proc joystick_destroy(device: joystick_device)
  proc joystick_enum(index: cint; namestrOutOptional: cstringArray): cstring
  proc joystick_getaxis(dev: joystick_device; axis: cint): cdouble
  proc joystick_getbuttonmask(dev: joystick_device): cuint
  proc joystick_getinfo(dev: joystick_device; axesOutOptional: ptr cint; povsOutOptional: ptr cint): cint
  proc joystick_getpov(dev: joystick_device; pov: cint): cdouble
  proc joystick_update(dev: joystick_device): bool
  proc kbd_enumerateActions(section: ptr KbdSectionInfo; idx: cint; nameOut: cstringArray): cint
  # proc kbd_formatKeyName(ac: ptr ACCEL; s: cstring)
  proc kbd_getCommandName(cmd: cint; s: cstring; section: ptr KbdSectionInfo)
  proc kbd_getTextFromCmd(cmd: DWORD; section: ptr KbdSectionInfo): cstring
  proc KBD_OnMainActionEx(cmd: cint; val: cint; valhw: cint; relmode: cint; hwnd: HWND; proj: ReaProject): cint
  proc kbd_OnMidiEvent(evt: ptr MIDI_event_t; dev_index: cint)
  # proc kbd_OnMidiList(list: ptr MIDI_eventlist; dev_index: cint)
  proc kbd_ProcessActionsMenu(menu: HMENU; section: ptr KbdSectionInfo)
  proc kbd_processMidiEventActionEx(evt: ptr MIDI_event_t; section: ptr KbdSectionInfo; hwndCtx: HWND): bool
  proc kbd_reprocessMenu(menu: HMENU; section: ptr KbdSectionInfo)
  proc kbd_RunCommandThroughHooks(section: ptr KbdSectionInfo; actionCommandID: ptr cint; val: ptr cint; valhw: ptr cint; relmode: ptr cint; hwnd: HWND): bool
  proc kbd_translateAccelerator(hwnd: HWND; msg: ptr MSG; section: ptr KbdSectionInfo): cint
  proc kbd_translateMouse(winmsg: pointer; midimsg: ptr uint8): bool
  # proc LICE_private_Destroy(bm: LICE_IBitmap) {.cdecl, importc: "LICE__Destroy".}
  # proc LICE_private_DestroyFont(font: ptr LICE_IFont) {.cdecl, importc: "LICE__DestroyFont".}
  # proc LICE_private_DrawText(font: ptr LICE_IFont; bm: LICE_IBitmap; str: cstring; strcnt: cint; rect: ptr RECT; dtFlags: UINT): cint {.cdecl, importc: "LICE__DrawText".}
  # proc LICE_private_GetBits(bm: LICE_IBitmap): pointer {.cdecl, importc: "LICE__GetBits".}
  # proc LICE_private_GetDC(bm: LICE_IBitmap): HDC {.cdecl, importc: "LICE__GetDC".}
  # proc LICE_private_GetHeight(bm: LICE_IBitmap): cint {.cdecl, importc: "LICE__GetHeight".}
  # proc LICE_private_GetRowSpan(bm: LICE_IBitmap): cint {.cdecl, importc: "LICE__GetRowSpan".}
  # proc LICE_private_GetWidth(bm: LICE_IBitmap): cint {.cdecl, importc: "LICE__GetWidth".}
  # proc LICE_private_IsFlipped(bm: LICE_IBitmap): bool {.cdecl, importc: "LICE__IsFlipped".}
  # proc LICE_private_resize(bm: LICE_IBitmap; w: cint; h: cint): bool {.cdecl, importc: "LICE__resize".}
  # proc LICE_private_SetBkColor(font: ptr LICE_IFont; color: LICE_pixel): LICE_pixel {.cdecl, importc: "LICE__SetBkColor".}
  # proc LICE_private_SetFromHFont(font: ptr LICE_IFont; hfont: HFONT; flags: cint) {.cdecl, importc: "LICE__SetFromHFont".}
  # proc LICE_private_SetTextColor(font: ptr LICE_IFont; color: LICE_pixel): LICE_pixel {.cdecl, importc: "LICE__SetTextColor".}
  # proc LICE_private_SetTextCombineMode(ifont: ptr LICE_IFont; mode: cint; alpha: cfloat) {.cdecl, importc: "LICE__SetTextCombineMode".}
  # proc LICE_Arc(dest: LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; minAngle: cfloat; maxAngle: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool)
  # proc LICE_Blit(dest: LICE_IBitmap; src: LICE_IBitmap; dstx: cint; dsty: cint; srcx: cint; srcy: cint; srcw: cint; srch: cint; alpha: cfloat; mode: cint)
  # proc LICE_Blur(dest: LICE_IBitmap; src: LICE_IBitmap; dstx: cint; dsty: cint; srcx: cint; srcy: cint; srcw: cint; srch: cint)
  # proc LICE_BorderedRect(dest: LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; bgcolor: LICE_pixel; fgcolor: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_Circle(dest: LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool)
  # proc LICE_Clear(dest: LICE_IBitmap; color: LICE_pixel)
  # proc LICE_ClearRect(dest: LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; mask: LICE_pixel; orbits: LICE_pixel)
  # proc LICE_ClipLine(pX1Out: ptr cint; pY1Out: ptr cint; pX2Out: ptr cint; pY2Out: ptr cint; xLo: cint; yLo: cint; xHi: cint; yHi: cint): bool
  # proc LICE_Copy(dest: LICE_IBitmap; src: LICE_IBitmap)
  # proc LICE_CreateBitmap(mode: cint; w: cint; h: cint): LICE_IBitmap
  # proc LICE_CreateFont(): ptr LICE_IFont
  # proc LICE_DrawCBezier(dest: LICE_IBitmap; xstart: cdouble; ystart: cdouble; xctl1: cdouble; yctl1: cdouble; xctl2: cdouble; yctl2: cdouble; xend: cdouble; yend: cdouble; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool; tol: cdouble)
  # proc LICE_DrawChar(bm: LICE_IBitmap; x: cint; y: cint; c: char; color: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_DrawGlyph(dest: LICE_IBitmap; x: cint; y: cint; color: LICE_pixel; alphas: ptr LICE_pixel_chan; glyph_w: cint; glyph_h: cint; alpha: cfloat; mode: cint)
  # proc LICE_DrawRect(dest: LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; color: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_DrawText(bm: LICE_IBitmap; x: cint; y: cint; string: cstring; color: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_FillCBezier(dest: LICE_IBitmap; xstart: cdouble; ystart: cdouble; xctl1: cdouble; yctl1: cdouble; xctl2: cdouble; yctl2: cdouble; xend: cdouble; yend: cdouble; yfill: cint; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool; tol: cdouble)
  # proc LICE_FillCircle(dest: LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool)
  # proc LICE_FillConvexPolygon(dest: LICE_IBitmap; x: ptr cint; y: ptr cint; npoints: cint; color: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_FillRect(dest: LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; color: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_FillTrapezoid(dest: LICE_IBitmap; x1a: cint; x1b: cint; y1: cint; x2a: cint; x2b: cint; y2: cint; color: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_FillTriangle(dest: LICE_IBitmap; x1: cint; y1: cint; x2: cint; y2: cint; x3: cint; y3: cint; color: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_GetPixel(bm: LICE_IBitmap; x: cint; y: cint): LICE_pixel
  # proc LICE_GradRect(dest: LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; ir: cfloat; ig: cfloat; ib: cfloat; ia: cfloat; drdx: cfloat; dgdx: cfloat; dbdx: cfloat; dadx: cfloat; drdy: cfloat; dgdy: cfloat; dbdy: cfloat; dady: cfloat; mode: cint)
  # proc LICE_Line(dest: LICE_IBitmap; x1: cfloat; y1: cfloat; x2: cfloat; y2: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool)
  # proc LICE_ThickFLine(dest: LICE_IBitmap, x1, y1, x2, y2: cdouble, color: LICE_pixel, alpha: cfloat, mode, wid: cint)
  # proc LICE_LineInt(dest: LICE_IBitmap; x1: cint; y1: cint; x2: cint; y2: cint; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool)
  # proc LICE_LoadPNG(filename: cstring; bmp: LICE_IBitmap): LICE_IBitmap
  # proc LICE_LoadPNGFromResource(hInst: HINSTANCE; resid: cstring; bmp: LICE_IBitmap): LICE_IBitmap
  # proc LICE_MeasureText(string: cstring; w: ptr cint; h: ptr cint)
  # proc LICE_MultiplyAddRect(dest: LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; rsc: cfloat; gsc: cfloat; bsc: cfloat; asc: cfloat; radd: cfloat; gadd: cfloat; badd: cfloat; aadd: cfloat)
  # proc LICE_PutPixel(bm: LICE_IBitmap; x: cint; y: cint; color: LICE_pixel; alpha: cfloat; mode: cint)
  # proc LICE_RotatedBlit(dest: LICE_IBitmap; src: LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; srcx: cfloat; srcy: cfloat; srcw: cfloat; srch: cfloat; angle: cfloat; cliptosourcerect: bool; alpha: cfloat; mode: cint; rotxcent: cfloat; rotycent: cfloat)
  # proc LICE_RoundRect(drawbm: LICE_IBitmap; xpos: cfloat; ypos: cfloat; w: cfloat; h: cfloat; cornerradius: cint; col: LICE_pixel; alpha: cfloat; mode: cint; aa: bool)
  # proc LICE_ScaledBlit(dest: LICE_IBitmap; src: LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; srcx: cfloat; srcy: cfloat; srcw: cfloat; srch: cfloat; alpha: cfloat; mode: cint)
  # proc LICE_SimpleFill(dest: LICE_IBitmap; x: cint; y: cint; newcolor: LICE_pixel; comparemask: LICE_pixel; keepmask: LICE_pixel)
  proc LocalizeString(src_string: cstring; section: cstring; flagsOptional: cint): cstring
  proc Loop_OnArrow(project: ReaProject; direction: cint): bool
  proc Main_OnCommand(command: cint; flag: cint)
  proc Main_OnCommandEx(command: cint; flag: cint; proj: ReaProject)
  proc Main_openProject(name: cstring)
  proc Main_SaveProject(proj: ReaProject; forceSaveAsInOptional: bool)
  proc Main_UpdateLoopInfo(ignoremask: cint)
  proc MarkProjectDirty(proj: ReaProject)
  proc MarkTrackItemsDirty(track: MediaTrack; item: MediaItem)
  proc Master_GetPlayRate(project: ReaProject): cdouble
  proc Master_GetPlayRateAtTime(time_s: cdouble; proj: ReaProject): cdouble
  proc Master_GetTempo(): cdouble
  proc Master_NormalizePlayRate(playrate: cdouble; isnormalized: bool): cdouble
  proc Master_NormalizeTempo(bpm: cdouble; isnormalized: bool): cdouble
  proc MB(msg: cstring; title: cstring; `type`: cint): cint
  proc MediaItemDescendsFromTrack(item: MediaItem; track: MediaTrack): cint
  proc MIDI_CountEvts(take: MediaItem_Take; notecntOut: ptr cint; ccevtcntOut: ptr cint; textsyxevtcntOut: ptr cint): cint
  proc MIDI_DeleteCC(take: MediaItem_Take; ccidx: cint): bool
  proc MIDI_DeleteEvt(take: MediaItem_Take; evtidx: cint): bool
  proc MIDI_DeleteNote(take: MediaItem_Take; noteidx: cint): bool
  proc MIDI_DeleteTextSysexEvt(take: MediaItem_Take; textsyxevtidx: cint): bool
  proc MIDI_DisableSort(take: MediaItem_Take)
  proc MIDI_EnumSelCC(take: MediaItem_Take; ccidx: cint): cint
  proc MIDI_EnumSelEvts(take: MediaItem_Take; evtidx: cint): cint
  proc MIDI_EnumSelNotes(take: MediaItem_Take; noteidx: cint): cint
  proc MIDI_EnumSelTextSysexEvts(take: MediaItem_Take; textsyxidx: cint): cint
  # proc MIDI_eventlist_Create(): ptr MIDI_eventlist
  # proc MIDI_eventlist_Destroy(evtlist: ptr MIDI_eventlist)
  proc MIDI_GetAllEvts(take: MediaItem_Take; bufNeedBig: cstring; bufNeedBig_sz: ptr cint): bool
  proc MIDI_GetCC(take: MediaItem_Take; ccidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; ppqposOut: ptr cdouble; chanmsgOut: ptr cint; chanOut: ptr cint; msg2Out: ptr cint; msg3Out: ptr cint): bool
  proc MIDI_GetCCShape(take: MediaItem_Take; ccidx: cint; shapeOut: ptr cint; beztensionOut: ptr cdouble): bool
  proc MIDI_GetEvt(take: MediaItem_Take; evtidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; ppqposOut: ptr cdouble; msg: cstring; msg_sz: ptr cint): bool
  proc MIDI_GetGrid(take: MediaItem_Take; swingOutOptional: ptr cdouble; noteLenOutOptional: ptr cdouble): cdouble
  proc MIDI_GetHash(take: MediaItem_Take; notesonly: bool; hash: cstring; hash_sz: cint): bool
  proc MIDI_GetNote(take: MediaItem_Take; noteidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; startppqposOut: ptr cdouble; endppqposOut: ptr cdouble; chanOut: ptr cint; pitchOut: ptr cint; velOut: ptr cint): bool
  proc MIDI_GetPPQPos_EndOfMeasure(take: MediaItem_Take; ppqpos: cdouble): cdouble
  proc MIDI_GetPPQPos_StartOfMeasure(take: MediaItem_Take; ppqpos: cdouble): cdouble
  proc MIDI_GetPPQPosFromProjQN(take: MediaItem_Take; projqn: cdouble): cdouble
  proc MIDI_GetPPQPosFromProjTime(take: MediaItem_Take; projtime: cdouble): cdouble
  proc MIDI_GetProjQNFromPPQPos(take: MediaItem_Take; ppqpos: cdouble): cdouble
  proc MIDI_GetProjTimeFromPPQPos(take: MediaItem_Take; ppqpos: cdouble): cdouble
  proc MIDI_GetScale(take: MediaItem_Take; rootOut: ptr cint; scaleOut: ptr cint; name: cstring; name_sz: cint): bool
  proc MIDI_GetTextSysexEvt(take: MediaItem_Take; textsyxevtidx: cint; selectedOutOptional: ptr bool; mutedOutOptional: ptr bool; ppqposOutOptional: ptr cdouble; typeOutOptional: ptr cint; msgOptional: cstring; msgOptional_sz: ptr cint): bool
  proc MIDI_GetTrackHash(track: MediaTrack; notesonly: bool; hash: cstring; hash_sz: cint): bool
  proc MIDI_InsertCC(take: MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; chanmsg: cint; chan: cint; msg2: cint; msg3: cint): bool
  proc MIDI_InsertEvt(take: MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; bytestr: cstring; bytestr_sz: cint): bool
  proc MIDI_InsertNote(take: MediaItem_Take; selected: bool; muted: bool; startppqpos: cdouble; endppqpos: cdouble; chan: cint; pitch: cint; vel: cint; noSortInOptional: ptr bool): bool
  proc MIDI_InsertTextSysexEvt(take: MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; `type`: cint; bytestr: cstring; bytestr_sz: cint): bool
  proc midi_reinit()
  proc MIDI_SelectAll(take: MediaItem_Take; select: bool)
  proc MIDI_SetAllEvts(take: MediaItem_Take; buf: cstring; buf_sz: cint): bool
  proc MIDI_SetCC(take: MediaItem_Take; ccidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; chanmsgInOptional: ptr cint; chanInOptional: ptr cint; msg2InOptional: ptr cint; msg3InOptional: ptr cint; noSortInOptional: ptr bool): bool
  proc MIDI_SetCCShape(take: MediaItem_Take; ccidx: cint; shape: cint; beztension: cdouble; noSortInOptional: ptr bool): bool
  proc MIDI_SetEvt(take: MediaItem_Take; evtidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; msgOptional: cstring; msgOptional_sz: cint; noSortInOptional: ptr bool): bool
  proc MIDI_SetItemExtents(item: MediaItem; startQN: cdouble; endQN: cdouble): bool
  proc MIDI_SetNote(take: MediaItem_Take; noteidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; startppqposInOptional: ptr cdouble; endppqposInOptional: ptr cdouble; chanInOptional: ptr cint; pitchInOptional: ptr cint; velInOptional: ptr cint; noSortInOptional: ptr bool): bool
  proc MIDI_SetTextSysexEvt(take: MediaItem_Take; textsyxevtidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; typeInOptional: ptr cint; msgOptional: cstring; msgOptional_sz: cint; noSortInOptional: ptr bool): bool
  proc MIDI_Sort(take: MediaItem_Take)
  proc MIDIEditor_GetActive(): HWND
  proc MIDIEditor_GetMode(midieditor: HWND): cint
  proc MIDIEditor_GetSetting_int(midieditor: HWND; setting_desc: cstring): cint
  proc MIDIEditor_GetSetting_str(midieditor: HWND; setting_desc: cstring; buf: cstring; buf_sz: cint): bool
  proc MIDIEditor_GetTake(midieditor: HWND): MediaItem_Take
  proc MIDIEditor_LastFocused_OnCommand(command_id: cint; islistviewcommand: bool): bool
  proc MIDIEditor_OnCommand(midieditor: HWND; command_id: cint): bool
  proc MIDIEditor_SetSetting_int(midieditor: HWND; setting_desc: cstring; setting: cint): bool
  proc mkpanstr(strNeed64: cstring; pan: cdouble)
  proc mkvolpanstr(strNeed64: cstring; vol: cdouble; pan: cdouble)
  proc mkvolstr(strNeed64: cstring; vol: cdouble)
  proc MoveEditCursor(adjamt: cdouble; dosel: bool)
  proc MoveMediaItemToTrack(item: MediaItem; desttr: MediaTrack): bool
  proc MuteAllTracks(mute: bool)
  proc my_getViewport(r: ptr RECT; sr: ptr RECT; wantWorkArea: bool)
  proc NamedCommandLookup(command_name: cstring): cint
  proc OnPauseButton()
  proc OnPauseButtonEx(proj: ReaProject)
  proc OnPlayButton()
  proc OnPlayButtonEx(proj: ReaProject)
  proc OnStopButton()
  proc OnStopButtonEx(proj: ReaProject)
  proc OpenColorThemeFile(fn: cstring): bool
  proc OpenMediaExplorer(mediafn: cstring; play: bool): HWND
  proc OscLocalMessageToHost(message: cstring; valueInOptional: ptr cdouble)
  proc parse_timestr(buf: cstring): cdouble
  proc parse_timestr_len(buf: cstring; offset: cdouble; modeoverride: cint): cdouble
  proc parse_timestr_pos(buf: cstring; modeoverride: cint): cdouble
  proc parsepanstr(str: cstring): cdouble
  # proc PCM_Sink_Create(filename: cstring; cfg: cstring; cfg_sz: cint; nch: cint; srate: cint; buildpeaks: bool): ptr PCM_sink
  # proc PCM_Sink_CreateEx(proj: ReaProject; filename: cstring; cfg: cstring; cfg_sz: cint; nch: cint; srate: cint; buildpeaks: bool): ptr PCM_sink
  # proc PCM_Sink_CreateMIDIFile(filename: cstring; cfg: cstring; cfg_sz: cint; bpm: cdouble; `div`: cint): ptr PCM_sink
  # proc PCM_Sink_CreateMIDIFileEx(proj: ReaProject; filename: cstring; cfg: cstring; cfg_sz: cint; bpm: cdouble; `div`: cint): ptr PCM_sink
  proc PCM_Sink_Enum(idx: cint; descstrOut: cstringArray): cuint
  proc PCM_Sink_GetExtension(data: cstring; data_sz: cint): cstring
  proc PCM_Sink_ShowConfig(cfg: cstring; cfg_sz: cint; hwndParent: HWND): HWND
  proc PCM_Source_CreateFromFile(filename: cstring): PCM_source
  proc PCM_Source_CreateFromFileEx(filename: cstring; forcenoMidiImp: bool): PCM_source
  # proc PCM_Source_CreateFromSimple(dec: ptr ISimpleMediaDecoder; fn: cstring): PCM_source
  proc PCM_Source_CreateFromType(sourcetype: cstring): PCM_source
  proc PCM_Source_Destroy(src: PCM_source)
  proc PCM_Source_GetPeaks(src: PCM_source; peakrate: cdouble; starttime: cdouble; numchannels: cint; numsamplesperchannel: cint; want_extra_type: cint; buf: ptr cdouble): cint
  proc PCM_Source_GetSectionInfo(src: PCM_source; offsOut: ptr cdouble; lenOut: ptr cdouble; revOut: ptr bool): bool
  # proc PeakBuild_Create(src: PCM_source; fn: cstring; srate: cint; nch: cint): ptr REAPER_PeakBuild_Interface
  # proc PeakBuild_CreateEx(src: PCM_source; fn: cstring; srate: cint; nch: cint; flags: cint): ptr REAPER_PeakBuild_Interface
  # proc PeakGet_Create(fn: cstring; srate: cint; nch: cint): ptr REAPER_PeakGet_Interface
  proc PitchShiftSubModeMenu(hwnd: HWND; x: cint; y: cint; mode: cint; submode_sel: cint): cint
  # proc PlayPreview(preview: ptr preview_register_t): cint
  # proc PlayPreviewEx(preview: ptr preview_register_t; bufflags: cint; measure_align: cdouble): cint
  # proc PlayTrackPreview(preview: ptr preview_register_t): cint
  # proc PlayTrackPreview2(proj: ReaProject; preview: ptr preview_register_t): cint
  # proc PlayTrackPreview2Ex(proj: ReaProject; preview: ptr preview_register_t; flags: cint; measure_align: cdouble): cint
  proc plugin_getapi(name: cstring): pointer
  proc plugin_getFilterList(): cstring
  proc plugin_getImportableProjectFilterList(): cstring
  proc plugin_register(name: cstring; infostruct: pointer): cint
  proc PluginWantsAlwaysRunFx(amt: cint)
  proc PreventUIRefresh(prevent_count: cint)
  proc projectconfig_var_addr(proj: ReaProject; idx: cint): pointer
  proc projectconfig_var_getoffs(name: cstring; szOut: ptr cint): cint
  proc PromptForAction(session_mode: cint; init_id: cint; section_id: cint): cint
  proc realloc_cmd_ptr(`ptr`: cstringArray; ptr_size: ptr cint; new_size: cint): bool
  # proc ReaperGetPitchShiftAPI(version: cint): ptr IReaperPitchShift
  proc ReaScriptError(errmsg: cstring)
  proc RecursiveCreateDirectory(path: cstring; ignored: csize_t): cint
  proc reduce_open_files(flags: cint): cint
  proc RefreshToolbar(command_id: cint)
  proc RefreshToolbar2(section_id: cint; command_id: cint)
  proc relative_fn(`in`: cstring; `out`: cstring; out_sz: cint)
  proc RemoveTrackSend(tr: MediaTrack; category: cint; sendidx: cint): bool
  proc RenderFileSection(source_filename: cstring; target_filename: cstring; start_percent: cdouble; end_percent: cdouble; playrate: cdouble): bool
  proc ReorderSelectedTracks(beforeTrackIdx: cint; makePrevFolder: cint): bool
  proc Resample_EnumModes(mode: cint): cstring
  # proc Resampler_Create(): ptr REAPER_Resample_Interface
  proc resolve_fn(`in`: cstring; `out`: cstring; out_sz: cint)
  proc resolve_fn2(`in`: cstring; `out`: cstring; out_sz: cint; checkSubDirOptional: cstring)
  proc ReverseNamedCommandLookup(command_id: cint): cstring
  proc ScaleFromEnvelopeMode(scaling_mode: cint; val: cdouble): cdouble
  proc ScaleToEnvelopeMode(scaling_mode: cint; val: cdouble): cdouble
  proc screenset_register(id: cstring; callbackFunc: pointer; param: pointer)
  # proc screenset_registerNew(id: cstring; callbackFunc: screensetNewCallbackFunc; param: pointer)
  proc screenset_unregister(id: cstring)
  proc screenset_unregisterByParam(param: pointer)
  proc screenset_updateLastFocus(prevWin: HWND)
  proc SectionFromUniqueID(uniqueID: cint): ptr KbdSectionInfo
  proc SelectAllMediaItems(proj: ReaProject; selected: bool)
  proc SelectProjectInstance(proj: ReaProject)
  proc SendLocalOscMessage(local_osc_handler: pointer; msg: cstring; msglen: cint)
  proc SetActiveTake(take: MediaItem_Take)
  proc SetAutomationMode(mode: cint; onlySel: bool)
  # proc SetCurrentBPM(__proj: ReaProject; bpm: cdouble; wantUndo: bool)
  proc SetCursorContext(mode: cint; envInOptional: TrackEnvelope)
  proc SetEditCurPos(time: cdouble; moveview: bool; seekplay: bool)
  proc SetEditCurPos2(proj: ReaProject; time: cdouble; moveview: bool; seekplay: bool)
  proc SetEnvelopePoint(envelope: TrackEnvelope; ptidx: cint; timeInOptional: ptr cdouble; valueInOptional: ptr cdouble; shapeInOptional: ptr cint; tensionInOptional: ptr cdouble; selectedInOptional: ptr bool; noSortInOptional: ptr bool): bool
  proc SetEnvelopePointEx(envelope: TrackEnvelope; autoitem_idx: cint; ptidx: cint; timeInOptional: ptr cdouble; valueInOptional: ptr cdouble; shapeInOptional: ptr cint; tensionInOptional: ptr cdouble; selectedInOptional: ptr bool; noSortInOptional: ptr bool): bool
  proc SetEnvelopeStateChunk(env: TrackEnvelope; str: cstring; isundoOptional: bool): bool
  proc SetExtState(section: cstring; key: cstring; value: cstring; persist: bool)
  proc SetGlobalAutomationOverride(mode: cint)
  proc SetItemStateChunk(item: MediaItem; str: cstring; isundoOptional: bool): bool
  proc SetMasterTrackVisibility(flag: cint): cint
  proc SetMediaItemInfo_Value(item: MediaItem; parmname: cstring; newvalue: cdouble): bool
  proc SetMediaItemLength(item: MediaItem; length: cdouble; refreshUI: bool): bool
  proc SetMediaItemPosition(item: MediaItem; position: cdouble; refreshUI: bool): bool
  proc SetMediaItemSelected(item: MediaItem; selected: bool)
  # proc SetMediaItemTake_Source(take: MediaItem_Take; source: PCM_source): bool
  proc SetMediaItemTakeInfo_Value(take: MediaItem_Take; parmname: cstring; newvalue: cdouble): bool
  proc SetMediaTrackInfo_Value(tr: MediaTrack; parmname: cstring; newvalue: cdouble): bool
  proc SetMIDIEditorGrid(project: ReaProject; division: cdouble)
  proc SetMixerScroll(leftmosttrack: MediaTrack): MediaTrack
  proc SetMouseModifier(context: cstring; modifier_flag: cint; action: cstring)
  proc SetOnlyTrackSelected(track: MediaTrack)
  proc SetProjectGrid(project: ReaProject; division: cdouble)
  proc SetProjectMarker(markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring): bool
  proc SetProjectMarker2(proj: ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring): bool
  proc SetProjectMarker3(proj: ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; color: cint): bool
  proc SetProjectMarker4(proj: ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; color: cint; flags: cint): bool
  proc SetProjectMarkerByIndex(proj: ReaProject; markrgnidx: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; IDnumber: cint; name: cstring; color: cint): bool
  proc SetProjectMarkerByIndex2(proj: ReaProject; markrgnidx: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; IDnumber: cint; name: cstring; color: cint; flags: cint): bool
  proc SetProjExtState(proj: ReaProject; extname: cstring; key: cstring; value: cstring): cint
  proc SetRegionRenderMatrix(proj: ReaProject; regionindex: cint; track: MediaTrack; addorremove: cint)
  proc SetRenderLastError(errorstr: cstring)
  proc SetTakeMarker(take: MediaItem_Take; idx: cint; nameIn: cstring; srcposInOptional: ptr cdouble; colorInOptional: ptr cint): cint
  proc SetTakeStretchMarker(take: MediaItem_Take; idx: cint; pos: cdouble; srcposInOptional: ptr cdouble): cint
  proc SetTakeStretchMarkerSlope(take: MediaItem_Take; idx: cint; slope: cdouble): bool
  proc SetTempoTimeSigMarker(proj: ReaProject; ptidx: cint; timepos: cdouble; measurepos: cint; beatpos: cdouble; bpm: cdouble; timesig_num: cint; timesig_denom: cint; lineartempo: bool): bool
  proc SetThemeColor(ini_key: cstring; color: cint; flagsOptional: cint): cint
  proc SetToggleCommandState(section_id: cint; command_id: cint; state: cint): bool
  proc SetTrackAutomationMode(tr: MediaTrack; mode: cint)
  proc SetTrackColor(track: MediaTrack; color: cint)
  proc SetTrackMIDILyrics(track: MediaTrack; flag: cint; str: cstring): bool
  proc SetTrackMIDINoteName(track: cint; pitch: cint; chan: cint; name: cstring): bool
  proc SetTrackMIDINoteNameEx(proj: ReaProject; track: MediaTrack; pitch: cint; chan: cint; name: cstring): bool
  proc SetTrackSelected(track: MediaTrack; selected: bool)
  proc SetTrackSendInfo_Value(tr: MediaTrack; category: cint; sendidx: cint; parmname: cstring; newvalue: cdouble): bool
  proc SetTrackSendUIPan(track: MediaTrack; send_idx: cint; pan: cdouble; isend: cint): bool
  proc SetTrackSendUIVol(track: MediaTrack; send_idx: cint; vol: cdouble; isend: cint): bool
  proc SetTrackStateChunk(track: MediaTrack; str: cstring; isundoOptional: bool): bool
  proc ShowActionList(caller: ptr KbdSectionInfo; callerWnd: HWND)
  proc ShowConsoleMsg(msg: cstring)
  proc ShowMessageBox(msg: cstring; title: cstring; `type`: cint): cint
  proc ShowPopupMenu(name: cstring; x: cint; y: cint; hwndParentOptional: HWND; ctxOptional: pointer; ctx2Optional: cint; ctx3Optional: cint)
  proc SLIDER2DB(y: cdouble): cdouble
  proc SnapToGrid(project: ReaProject; time_pos: cdouble): cdouble
  proc SoloAllTracks(solo: cint)
  proc Splash_GetWnd(): HWND
  proc SplitMediaItem(item: MediaItem; position: cdouble): MediaItem
  # proc StopPreview(preview: ptr preview_register_t): cint
  # proc StopTrackPreview(preview: ptr preview_register_t): cint
  # proc StopTrackPreview2(proj: pointer; preview: ptr preview_register_t): cint
  proc stringToGuid(str: cstring; g: ptr GUID)
  proc StuffMIDIMessage(mode: cint; msg1: cint; msg2: cint; msg3: cint)
  proc TakeFX_AddByName(take: MediaItem_Take; fxname: cstring; instantiate: cint): cint
  proc TakeFX_CopyToTake(src_take: MediaItem_Take; src_fx: cint; dest_take: MediaItem_Take; dest_fx: cint; is_move: bool)
  proc TakeFX_CopyToTrack(src_take: MediaItem_Take; src_fx: cint; dest_track: MediaTrack; dest_fx: cint; is_move: bool)
  proc TakeFX_Delete(take: MediaItem_Take; fx: cint): bool
  proc TakeFX_EndParamEdit(take: MediaItem_Take; fx: cint; param: cint): bool
  proc TakeFX_FormatParamValue(take: MediaItem_Take; fx: cint; param: cint; val: cdouble; buf: cstring; buf_sz: cint): bool
  proc TakeFX_FormatParamValueNormalized(take: MediaItem_Take; fx: cint; param: cint; value: cdouble; buf: cstring; buf_sz: cint): bool
  proc TakeFX_GetChainVisible(take: MediaItem_Take): cint
  proc TakeFX_GetCount(take: MediaItem_Take): cint
  proc TakeFX_GetEnabled(take: MediaItem_Take; fx: cint): bool
  proc TakeFX_GetEnvelope(take: MediaItem_Take; fxindex: cint; parameterindex: cint; create: bool): TrackEnvelope
  proc TakeFX_GetFloatingWindow(take: MediaItem_Take; index: cint): HWND
  proc TakeFX_GetFormattedParamValue(take: MediaItem_Take; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool
  proc TakeFX_GetFXGUID(take: MediaItem_Take; fx: cint): ptr GUID
  proc TakeFX_GetFXName(take: MediaItem_Take; fx: cint; buf: cstring; buf_sz: cint): bool
  proc TakeFX_GetIOSize(take: MediaItem_Take; fx: cint; inputPinsOutOptional: ptr cint; outputPinsOutOptional: ptr cint): cint
  proc TakeFX_GetNamedConfigParm(take: MediaItem_Take; fx: cint; parmname: cstring; bufOut: cstring; bufOut_sz: cint): bool
  proc TakeFX_GetNumParams(take: MediaItem_Take; fx: cint): cint
  proc TakeFX_GetOffline(take: MediaItem_Take; fx: cint): bool
  proc TakeFX_GetOpen(take: MediaItem_Take; fx: cint): bool
  proc TakeFX_GetParam(take: MediaItem_Take; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble): cdouble
  proc TakeFX_GetParameterStepSizes(take: MediaItem_Take; fx: cint; param: cint; stepOut: ptr cdouble; smallstepOut: ptr cdouble; largestepOut: ptr cdouble; istoggleOut: ptr bool): bool
  proc TakeFX_GetParamEx(take: MediaItem_Take; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble; midvalOut: ptr cdouble): cdouble
  proc TakeFX_GetParamName(take: MediaItem_Take; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool
  proc TakeFX_GetParamNormalized(take: MediaItem_Take; fx: cint; param: cint): cdouble
  proc TakeFX_GetPinMappings(tr: MediaItem_Take; fx: cint; isoutput: cint; pin: cint; high32OutOptional: ptr cint): cint
  proc TakeFX_GetPreset(take: MediaItem_Take; fx: cint; presetname: cstring; presetname_sz: cint): bool
  proc TakeFX_GetPresetIndex(take: MediaItem_Take; fx: cint;numberOfPresetsOut: ptr cint): cint
  proc TakeFX_GetUserPresetFilename(take: MediaItem_Take; fx: cint; fn: cstring; fn_sz: cint)
  proc TakeFX_NavigatePresets(take: MediaItem_Take; fx: cint; presetmove: cint): bool
  proc TakeFX_SetEnabled(take: MediaItem_Take; fx: cint; enabled: bool)
  proc TakeFX_SetNamedConfigParm(take: MediaItem_Take; fx: cint; parmname: cstring; value: cstring): bool
  proc TakeFX_SetOffline(take: MediaItem_Take; fx: cint; offline: bool)
  proc TakeFX_SetOpen(take: MediaItem_Take; fx: cint; open: bool)
  proc TakeFX_SetParam(take: MediaItem_Take; fx: cint; param: cint; val: cdouble): bool
  proc TakeFX_SetParamNormalized(take: MediaItem_Take; fx: cint; param: cint; value: cdouble): bool
  proc TakeFX_SetPinMappings(tr: MediaItem_Take; fx: cint; isoutput: cint; pin: cint; low32bits: cint; hi32bits: cint): bool
  proc TakeFX_SetPreset(take: MediaItem_Take; fx: cint; presetname: cstring): bool
  proc TakeFX_SetPresetByIndex(take: MediaItem_Take; fx: cint; idx: cint): bool
  proc TakeFX_Show(take: MediaItem_Take; index: cint; showFlag: cint)
  proc TakeIsMIDI(take: MediaItem_Take): bool
  proc ThemeLayout_GetLayout(section: cstring; idx: cint; nameOut: cstring; nameOut_sz: cint): bool
  proc ThemeLayout_GetParameter(wp: cint; descOutOptional: cstringArray; valueOutOptional: ptr cint; defValueOutOptional: ptr cint; minValueOutOptional: ptr cint; maxValueOutOptional: ptr cint): cstring
  proc ThemeLayout_RefreshAll()
  proc ThemeLayout_SetLayout(section: cstring; layout: cstring): bool
  proc ThemeLayout_SetParameter(wp: cint; value: cint; persist: bool): bool
  proc time_precise(): cdouble
  proc TimeMap2_beatsToTime(proj: ReaProject; tpos: cdouble; measuresInOptional: ptr cint): cdouble
  proc TimeMap2_GetDividedBpmAtTime(proj: ReaProject; time: cdouble): cdouble
  proc TimeMap2_GetNextChangeTime(proj: ReaProject; time: cdouble): cdouble
  proc TimeMap2_QNToTime(proj: ReaProject; qn: cdouble): cdouble
  proc TimeMap2_timeToBeats(proj: ReaProject; tpos: cdouble; measuresOutOptional: ptr cint; cmlOutOptional: ptr cint; fullbeatsOutOptional: ptr cdouble; cdenomOutOptional: ptr cint): cdouble
  proc TimeMap2_timeToQN(proj: ReaProject; tpos: cdouble): cdouble
  proc TimeMap_curFrameRate(proj: ReaProject; dropFrameOutOptional: ptr bool): cdouble
  proc TimeMap_GetDividedBpmAtTime(time: cdouble): cdouble
  proc TimeMap_GetMeasureInfo(proj: ReaProject; measure: cint; qn_startOut: ptr cdouble; qn_endOut: ptr cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; tempoOut: ptr cdouble): cdouble
  proc TimeMap_GetMetronomePattern(proj: ReaProject; time: cdouble; pattern: cstring; pattern_sz: cint): cint
  proc TimeMap_GetTimeSigAtTime(proj: ReaProject; time: cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; tempoOut: ptr cdouble)
  proc TimeMap_QNToMeasures(proj: ReaProject; qn: cdouble; qnMeasureStartOutOptional: ptr cdouble; qnMeasureEndOutOptional: ptr cdouble): cint
  proc TimeMap_QNToTime(qn: cdouble): cdouble
  proc TimeMap_QNToTime_abs(proj: ReaProject; qn: cdouble): cdouble
  proc TimeMap_timeToQN(tpos: cdouble): cdouble
  proc TimeMap_timeToQN_abs(proj: ReaProject; tpos: cdouble): cdouble
  proc ToggleTrackSendUIMute(track: MediaTrack; send_idx: cint): bool
  proc Track_GetPeakHoldDB(track: MediaTrack; channel: cint; clear: bool): cdouble
  proc Track_GetPeakInfo(track: MediaTrack; channel: cint): cdouble
  proc TrackCtl_SetToolTip(fmt: cstring; xpos: cint; ypos: cint; topmost: bool)
  proc TrackFX_AddByName(track: MediaTrack; fxname: cstring; recFX: bool; instantiate: cint): cint
  proc TrackFX_CopyToTake(src_track: MediaTrack; src_fx: cint; dest_take: MediaItem_Take; dest_fx: cint; is_move: bool)
  proc TrackFX_CopyToTrack(src_track: MediaTrack; src_fx: cint; dest_track: MediaTrack; dest_fx: cint; is_move: bool)
  proc TrackFX_Delete(track: MediaTrack; fx: cint): bool
  proc TrackFX_EndParamEdit(track: MediaTrack; fx: cint; param: cint): bool
  proc TrackFX_FormatParamValue(track: MediaTrack; fx: cint; param: cint; val: cdouble; buf: cstring; buf_sz: cint): bool
  proc TrackFX_FormatParamValueNormalized(track: MediaTrack; fx: cint; param: cint; value: cdouble; buf: cstring; buf_sz: cint): bool
  proc TrackFX_GetByName(track: MediaTrack; fxname: cstring; instantiate: bool): cint
  proc TrackFX_GetChainVisible(track: MediaTrack): cint
  proc TrackFX_GetCount(track: MediaTrack): cint
  proc TrackFX_GetEnabled(track: MediaTrack; fx: cint): bool
  proc TrackFX_GetEQ(track: MediaTrack; instantiate: bool): cint
  proc TrackFX_GetEQBandEnabled(track: MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint): bool
  proc TrackFX_GetEQParam(track: MediaTrack; fxidx: cint; paramidx: cint; bandtypeOut: ptr cint; bandidxOut: ptr cint; paramtypeOut: ptr cint; normvalOut: ptr cdouble): bool
  proc TrackFX_GetFloatingWindow(track: MediaTrack; index: cint): HWND
  proc TrackFX_GetFormattedParamValue(track: MediaTrack; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool
  proc TrackFX_GetFXGUID(track: MediaTrack; fx: cint): ptr GUID
  proc TrackFX_GetFXName(track: MediaTrack; fx: cint; buf: cstring; buf_sz: cint): bool
  proc TrackFX_GetInstrument(track: MediaTrack): cint
  proc TrackFX_GetIOSize(track: MediaTrack; fx: cint; inputPinsOutOptional: ptr cint; outputPinsOutOptional: ptr cint): cint
  proc TrackFX_GetNamedConfigParm(track: MediaTrack; fx: cint; parmname: cstring; bufOut: cstring; bufOut_sz: cint): bool
  proc TrackFX_GetNumParams(track: MediaTrack; fx: cint): cint
  proc TrackFX_GetOffline(track: MediaTrack; fx: cint): bool
  proc TrackFX_GetOpen(track: MediaTrack; fx: cint): bool
  proc TrackFX_GetParam(track: MediaTrack; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble): cdouble
  proc TrackFX_GetParameterStepSizes(track: MediaTrack; fx: cint; param: cint; stepOut: ptr cdouble; smallstepOut: ptr cdouble; largestepOut: ptr cdouble; istoggleOut: ptr bool): bool
  proc TrackFX_GetParamEx(track: MediaTrack; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble; midvalOut: ptr cdouble): cdouble
  proc TrackFX_GetParamName(track: MediaTrack; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool
  proc TrackFX_GetParamNormalized(track: MediaTrack; fx: cint; param: cint): cdouble
  proc TrackFX_GetPinMappings(tr: MediaTrack; fx: cint; isoutput: cint; pin: cint; high32OutOptional: ptr cint): cint
  proc TrackFX_GetPreset(track: MediaTrack; fx: cint; presetname: cstring; presetname_sz: cint): bool
  proc TrackFX_GetPresetIndex(track: MediaTrack; fx: cint; numberOfPresetsOut: ptr cint): cint
  proc TrackFX_GetRecChainVisible(track: MediaTrack): cint
  proc TrackFX_GetRecCount(track: MediaTrack): cint
  proc TrackFX_GetUserPresetFilename(track: MediaTrack; fx: cint; fn: cstring; fn_sz: cint)
  proc TrackFX_NavigatePresets(track: MediaTrack; fx: cint; presetmove: cint): bool
  proc TrackFX_SetEnabled(track: MediaTrack; fx: cint; enabled: bool)
  proc TrackFX_SetEQBandEnabled(track: MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint; enable: bool): bool
  proc TrackFX_SetEQParam(track: MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint; paramtype: cint; val: cdouble; isnorm: bool): bool
  proc TrackFX_SetNamedConfigParm(track: MediaTrack; fx: cint; parmname: cstring; value: cstring): bool
  proc TrackFX_SetOffline(track: MediaTrack; fx: cint; offline: bool)
  proc TrackFX_SetOpen(track: MediaTrack; fx: cint; open: bool)
  proc TrackFX_SetParam(track: MediaTrack; fx: cint; param: cint; val: cdouble): bool
  proc TrackFX_SetParamNormalized(track: MediaTrack; fx: cint; param: cint; value: cdouble): bool
  proc TrackFX_SetPinMappings(tr: MediaTrack; fx: cint; isoutput: cint; pin: cint; low32bits: cint; hi32bits: cint): bool
  proc TrackFX_SetPreset(track: MediaTrack; fx: cint; presetname: cstring): bool
  proc TrackFX_SetPresetByIndex(track: MediaTrack; fx: cint; idx: cint): bool
  proc TrackFX_Show(track: MediaTrack; index: cint; showFlag: cint)
  proc TrackList_AdjustWindows(isMinor: bool)
  proc TrackList_UpdateAllExternalSurfaces()
  proc Undo_BeginBlock()
  proc Undo_BeginBlock2(proj: ReaProject)
  proc Undo_CanRedo2(proj: ReaProject): cstring
  proc Undo_CanUndo2(proj: ReaProject): cstring
  proc Undo_DoRedo2(proj: ReaProject): cint
  proc Undo_DoUndo2(proj: ReaProject): cint
  proc Undo_EndBlock(descchange: cstring; extraflags: cint)
  proc Undo_EndBlock2(proj: ReaProject; descchange: cstring; extraflags: cint)
  proc Undo_OnStateChange(descchange: cstring)
  proc Undo_OnStateChange2(proj: ReaProject; descchange: cstring)
  proc Undo_OnStateChange_Item(proj: ReaProject; name: cstring; item: MediaItem)
  proc Undo_OnStateChangeEx(descchange: cstring; whichStates: cint; trackparm: cint)
  proc Undo_OnStateChangeEx2(proj: ReaProject; descchange: cstring; whichStates: cint; trackparm: cint)
  proc update_disk_counters(readamt: cint; writeamt: cint)
  proc UpdateArrange()
  proc UpdateItemInProject(item: MediaItem)
  proc UpdateTimeline()
  proc ValidatePtr(`pointer`: pointer; ctypename: cstring): bool
  proc ValidatePtr2(proj: ReaProject; `pointer`: pointer; ctypename: cstring): bool
  proc ViewPrefs(page: cint; pageByName: cstring)
  # proc WDL_VirtualWnd_ScaledBlitBG(dest: LICE_IBitmap; src: WDL_VirtualWnd_BGCfg; destx: cint; desty: cint; destw: cint; desth: cint; clipx: cint; clipy: cint; clipw: cint; cliph: cint; alpha: cfloat; mode: cint): bool