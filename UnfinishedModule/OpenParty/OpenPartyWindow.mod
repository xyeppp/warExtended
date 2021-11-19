<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Open Party" version="1.0" date="08/30/2021" >
        <Replaces name="EA_OpenPartyWindow" />
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.0" />
        <Description text="warHelper Open Party Module" />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EATemplate_Icons" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EASystem_Tooltips" />
            <Dependency name="EA_GroupWindow" />
            <Dependency name="EA_PlayerStatusWindow" />
            <Dependency name="EA_PlayerMenu" />
            <Dependency name="EA_ContextMenu" />
        </Dependencies>
        <Files>
            <File name="Source/OpenPartyWindowCommon.xml" />
            <File name="Source/OpenPartyWindowTabNearby.xml" />
            <File name="Source/OpenPartyWindowTabWorld.xml" />
            <File name="Source/OpenPartyWindowTabLootRollOptions.xml" />
            <File name="Source/OpenPartyWindowTabManage.xml" />
            <File name="Source/OpenPartyWindow.xml" />
            <File name="OpenParty.lua" />
        </Files>
        <OnInitialize>
            <CreateWindow name="EA_Window_OpenPartyFlyOutAnchor" show="false" />
            <CreateWindow name="EA_Window_OpenPartyFlyOut" show="true" />
            <CreateWindow name="EA_Window_OpenParty" show="false" />
            <CallFunction name="warExtendedOpenParty.OnInitialize" />
        </OnInitialize>
        <SavedVariables>
            <SavedVariable name="EA_Window_OpenPartyWorld.Settings" />
            <SavedVariable name="EA_Window_OpenPartyLootRollOptions.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
