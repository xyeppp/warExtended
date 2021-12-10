<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Macro Window" version="1.1" date="17/08/21" >
        <Replaces name="EA_MacroWindow" />
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.2" />
        <Description text="warExtended Macro Module." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
        </Dependencies>

        <Files>
            <File name="Source/MacroWindow.xml" />
            <File name="Source/MacroWindow.lua" />
            <File name="MacroWindow.lua"  />
        </Files>
        <OnInitialize>
            <CreateWindow name="MacroIconSelectionWindow" show="false" />
            <CreateWindow name="EA_Window_Macro" show="false" />
            <CallFunction name="warExtendedMacro.Initialize" />
        </OnInitialize>
        <OnShutdown>
            <CallFunction name="warExtendedMacro.Shutdown" />
        </OnShutdown>
           <SavedVariables>
               <SavedVariable name="warExtendedMacro.Sets" />
            <SavedVariable name="warExtendedMacro.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
