local DialogManager = DialogManager
local LabelSetText = LabelSetText
local TextEditBoxSetText = TextEditBoxSetText
local TextEditBoxSetMaxChars = TextEditBoxSetMaxChars
local WindowSetShowing = WindowSetShowing
local WindowAssignFocus = WindowAssignFocus
local TextEditBoxSelectAll = TextEditBoxSelectAll
local ButtonSetText = ButtonSetText
local CreateWindow = CreateWindow

local function NewDialogPosition()
  return {inUse = false,
		  xOffset = 0,
		  yOffset = 0}
end

local function NewTextEntryDialogData()
  return { inUse = false,
		   id=DialogManager.UNTYPED_ID,
		   SubmitCallback = nil,
		   CancelCallback = nil }
end

DialogManager.NUM_DOUBLETEXT_ENTRY_DLGS = 5
DialogManager.doubleTextEntryDlgs = {}

DialogManager.NUM_DIALOG_POSITIONS = 5

DialogManager.dialogPositions[ 5 ] = NewDialogPosition()
DialogManager.dialogPositions[ 5 ].xOffset = xSize
DialogManager.dialogPositions[ 5 ].yOffset = ySize

for dlg = 1, DialogManager.NUM_DOUBLETEXT_ENTRY_DLGS do
  DialogManager.doubleTextEntryDlgs[ dlg ] = NewTextEntryDialogData()
  CreateWindow( "DoubleTextEntryDlg"..dlg, false )
  ButtonSetText( "DoubleTextEntryDlg"..dlg.."ButtonCancel", GetPregameString(StringTables.Pregame.LABEL_CANCEL) );
  ButtonSetText( "DoubleTextEntryDlg"..dlg.."ButtonSubmit", GetPregameString(StringTables.Pregame.LABEL_SUBMIT) );
end

function DialogManager.MakeDoubleTextEntryDialog( dialogTitle, dialogText, defaultUserText, dialogText2, defaultUserText2, submitCallback, cancelCallback, maxChars, dialogID )
  local startIndex = 1
  local dlgIndex = DialogManager.FindAvailableDialog( DialogManager.doubleTextEntryDlgs, DialogManager.NUM_DOUBLETEXT_ENTRY_DLGS, startIndex )
  if ( dlgIndex == nil )
  then
	return
  end

  if( maxChars == nil )
  then
	maxChars = DialogManager.DEFAULT_MAX_CHARS
  end

  -- Set the dialog's parameters.
  DialogManager.doubleTextEntryDlgs[ dlgIndex ].inUse = true;
  DialogManager.doubleTextEntryDlgs[ dlgIndex ].SubmitCallback      = submitCallback;
  DialogManager.doubleTextEntryDlgs[ dlgIndex ].CancelCallback      = cancelCallback;
  DialogManager.doubleTextEntryDlgs[ dlgIndex ].id                  = dialogID;
  DialogManager.doubleTextEntryDlgs[ dlgIndex ].dialogPosition      = DialogManager.FindAvailablePosition()
  -- Setup its components.
  LabelSetText( "DoubleTextEntryDlg"..dlgIndex.."TitleBarText", dialogTitle )
  LabelSetText( "DoubleTextEntryDlg"..dlgIndex.."TextLabel", dialogText )
  TextEditBoxSetText( "DoubleTextEntryDlg"..dlgIndex.."TextEntry", defaultUserText )
  LabelSetText( "DoubleTextEntryDlg"..dlgIndex.."TextLabel2", dialogText2 )
  TextEditBoxSetText( "DoubleTextEntryDlg"..dlgIndex.."TextEntry2", defaultUserText2 )
  TextEditBoxSetMaxChars( "DoubleTextEntryDlg"..dlgIndex.."TextEntry", maxChars )
  -- Finally, show the dialog.
  WindowSetShowing( "DoubleTextEntryDlg"..dlgIndex, true )
  WindowAssignFocus( "DoubleTextEntryDlg"..dlgIndex.."TextEntry", true )
  TextEditBoxSelectAll( "DoubleTextEntryDlg"..dlgIndex.."TextEntry" )
end

function DialogManager.SubmitDoubleTextEntryDialog( dlgIndex )
  if ( dlgIndex < 1 or dlgIndex > DialogManager.NUM_DOUBLETEXT_ENTRY_DLGS ) then
	return
  end

  if ( DialogManager.doubleTextEntryDlgs[ dlgIndex ].SubmitCallback ~= nil ) then
	DialogManager.doubleTextEntryDlgs[ dlgIndex ].SubmitCallback( TextEditBoxGetText( "DoubleTextEntryDlg"..dlgIndex.."TextEntry" ), TextEditBoxGetText("DoubleTextEntryDlg"..dlgIndex.."TextEntry2") )
  end

  DialogManager.ReleaseDialog(DialogManager.doubleTextEntryDlgs[ dlgIndex ], "DoubleTextEntryDlg"..dlgIndex)

  -- Ideally this should be done automatically when the window is hidden, but whatever.
  WindowAssignFocus( "DoubleTextEntryDlg"..dlgIndex.."TextEntry", false )
end


function DialogManager.CancelDoubleTextEntryDialog( dlgIndex )
  if ( dlgIndex < 1 or dlgIndex > DialogManager.NUM_DOUBLETEXT_ENTRY_DLGS ) then
	return
  end

  if ( DialogManager.doubleTextEntryDlgs[ dlgIndex ].CancelCallback ~= nil ) then
	DialogManager.doubleTextEntryDlgs[ dlgIndex ].CancelCallback()
  end

  DialogManager.ReleaseDialog(DialogManager.doubleTextEntryDlgs[ dlgIndex ], "DoubleTextEntryDlg"..dlgIndex)

  -- Ideally this should be done automatically when the window is hidden, but whatever.
  WindowAssignFocus( "DoubleTextEntryDlg"..dlgIndex.."TextEntry", false )
end

function DialogManager.OnDoubleTextEntryDlgButtonSubmit()
  local dlgIndex = WindowGetId( WindowGetParent(SystemData.ActiveWindow.name) )
  DialogManager.SubmitDoubleTextEntryDialog( dlgIndex )
end

function DialogManager.OnDoubleTextEntryDlgButtonCancel()
  local dlgIndex = WindowGetId( WindowGetParent(SystemData.ActiveWindow.name) )
  DialogManager.CancelDoubleTextEntryDialog( dlgIndex )
end

function DialogManager.OnDoubleTextEntryDlgKeyEnter()
  local dlgIndex = WindowGetId( WindowGetParent(SystemData.ActiveWindow.name) )
  DialogManager.SubmitDoubleTextEntryDialog( dlgIndex )
end

function DialogManager.OnDoubleTextEntryDlgKeyEscape()
  local dlgIndex = WindowGetId( SystemData.ActiveWindow.name )
  DialogManager.CancelDoubleTextEntryDialog( dlgIndex )
end

