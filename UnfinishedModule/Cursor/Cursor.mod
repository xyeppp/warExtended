<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Cursor" version="1.0" date="11/6/2007" >
        <Author name="xyeppp" email="" />
        <Replaces name="EA_Cursor" />
        <Description text="This module contains the EA Default cursor management system." />
        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EASystem_DialogManager" />
        </Dependencies>
        <Files>
            <File name="Source/Cursor.lua" />
            <File name="Core.lua"  />
        </Files>
        <OnInitialize>
            <CreateWindow name="CursorWindow" show="false" />
            <CallFunction name="Cursor.Initialize" />

            <CallFunction name="warExtendedCursor.OnInitialize" />
        </OnInitialize>
        <OnUpdate>
            <CallFunction name="Cursor.Update" />
        </OnUpdate>
        <OnShutdown>
            <CallFunction name="Cursor.Shutdown" />
        </OnShutdown>

        <SavedVariables>
            <SavedVariable name="warExtendedCursor.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>

