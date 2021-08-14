<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warHelper Macro Module" version="1.4" date="14/06/21" >
        <Replaces name="EA_MacroWindow" />
        <Author name="EAMythic | changes by anon + xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.0" />
        <Description text="This module contains the modified bigger_MacroWindow for warHelper." />
        <Dependencies>
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EASystem_Tooltips" />
        </Dependencies>
        <Files>
            <File name="Source/MacroWindow.xml" />
            <File name="Source/MacroWindow.lua" />
        </Files>
        <OnInitialize>
            <CreateWindow name="MacroIconSelectionWindow" show="false" />
            <CreateWindow name="EA_Window_Macro" show="false" />
        </OnInitialize>
    </UiMod>

</ModuleFile>
