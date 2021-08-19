<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended Core" version="1.4" date="14/06/21">
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
            <Dependency name="LibSlash"/>
        </Dependencies>

        <Files>
            <File name="warExtendedUtils.lua" />
            <File name="warExtendedSlashCore.lua" />
            <File name="warExtendedSlashEmotes.lua" />
            <File name="warExtendedModules.lua" />
            <File name="warExtendedHyperlinks.lua" />
            <File name="warExtendedHooks.lua" />
            <File name="warExtendedCore.lua" />
          </Files>

        <OnInitialize>
            <CallFunction name="warExtended.Initialize" />
        </OnInitialize>

        <OnShutdown>
            <CallFunction name="warExtended.OnShutdown" />
        </OnShutdown>

        <SavedVariables>
            <SavedVariable name="warExtended.Settings" />
            <!--<SavedVariable name="warExtended.Modules" /> -->
        </SavedVariables>
    </UiMod>
</ModuleFile>
