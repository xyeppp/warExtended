<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Ui Mod Window" version="3.1" date="12/8/2008" >
        <Author name="xyeppp" email="" />
        <Replaces name="EA_UiModWindow"/>
        <Description text="This module contains the EA Default Ui Mod Settings Window." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_DefaultWindowSkin" />     
            <Dependency name="EASystem_WindowUtils" />        
        </Dependencies>

        <Files>
            <File name="Core.lua" />
            <File name="Search.lua" />
            <File name="Profiles.lua" />

            <File name="Original/Source/UiModInfoTemplate.xml" />
            <File name="Original/Source/UiModWindow.xml" />
            <File name="Original/Source/UiModAdvancedWindow.xml" />
            <File name="Original/Source/VersionMismatchWindow.xml" />
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