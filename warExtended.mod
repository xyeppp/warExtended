<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended" version="1.4" date="14/06/21">
    <VersionSettings gameVersion="1.4.8" windowsVersion="1.0" savedVariablesVersion="1.4" />
    <Author name="xyeppp" />
    <Description text="warExtended is a combination of addons designed to bring Quality of Life improvements to Warhammer Online." />
        <Dependencies>
            <Dependency name="EA_ChatWindow" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EASystem_Tooltips" />
            <Dependency name="EA_AbilitiesWindow" />
            <Dependency name="EA_BackpackWindow" />
            <Dependency name="EA_OpenPartyWindow"/>
        </Dependencies>

        <Files>
            <File name="warExtendedUtils.lua" />
            <File name="warExtendedCore.lua" />
            <File name="warExtendedSlash.lua" />
            <File name="warExtendedEmotes.lua" />
            <File name="warExtendedHyperlinks.lua" />
            <File name="warExtendedHooks.lua" />
            <File name="macro/warExtendedMacros.lua" />
          </Files>

        <OnInitialize>
            <CallFunction name="warExtended.Initialize" />
        </OnInitialize>

        <OnShutdown>
            <CallFunction name="warExtended.OnShutdown" />
        </OnShutdown>

        <SavedVariables>
            <SavedVariable name="warExtended.Settings" />
        </SavedVariables>
    </UiMod>
</ModuleFile>
