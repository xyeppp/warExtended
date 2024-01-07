<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended UI Mods/Addons" version="1.0" date="14/12/2022" >
        <Author name="xyeppp" email="" />
        <Replaces name="EA_UiModWindow" />
        <Description text="This module contains the EA Default Ui Mod Settings Window." />
        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_UiProfilesWindow" />
        </Dependencies>
        <Files>
            <File name="Source/UiModInfoTemplate.xml" />
            <File name="Source/UiModWindow.xml" />
            <File name="Source/UiModAdvancedWindow.lua" />
            <File name="Source/UiModAdvancedWindow.xml" />
            <File name="Source/VersionMismatchWindow.xml" />

            <File name="Core.lua" />
            <File name="Window.lua" />
        </Files>
        <OnInitialize>
            <CreateWindow name="UiModWindow" show="false" />
            <CreateWindow name="UiModAdvancedWindow" show="false" />
            <CreateWindow name="UiModVersionMismatchWindow" show="false" />
            <CallFunction name="warExtendedUiMod.OnInitialize" />
        </OnInitialize>
        <SavedVariables>
            <SavedVariable name="UiModWindow.Settings" />
            <SavedVariable name="warExtendedUiMod.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>