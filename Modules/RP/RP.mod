<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Renown Bar" version="1.0" date="17/07/23" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0"/>
        <Description text="This module replaces the default player renown window and expands on it's function." />

        <Replaces name="EA_RpBarWindow"/>

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EASystem_Tooltips" />
            <Dependency name="EASystem_LayoutEditor" />
            <Dependency name="EASystem_AdvancedWindowManager" />
        </Dependencies>

        <Files>
            <File name="Window.xml"  />
        </Files>

        <OnInitialize>
            <CreateWindow name="warExtendedRenownBar" show="true" />
        </OnInitialize>
    </UiMod>

</ModuleFile>
