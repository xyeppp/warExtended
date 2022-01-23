<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Main Menu" version="1.1" date="11/6/2007" >
        <Author name="EAMythic" email="" />
        <Replaces name="EA_MainMenuWindow"/>
        <Description text="Tweaks the default Main Menu window adding a UI Mods/Addons and warExtended Settings buttons - removes unused Account Entitlements."/>
        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EATemplate_Icons" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_KeyMappingWindow" />
            <Dependency name="EA_MacroWindow" />
            <Dependency name="EA_TrialAlertWindow" />
            <Dependency name="EA_SettingsWindow" />
        </Dependencies>
        <Files>
            <File name="Core.lua" />
            <File name="Original/Textures/MenuTextures.xml" />
            <File name="Original/Source/MainMenuWindow.xml" />
        </Files>
        <OnInitialize>
            <CreateWindow name="MainMenuWindow" show="false" />
        </OnInitialize>
    </UiMod>

</ModuleFile>