<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended War Report" version="1.2" date="11/6/2021" >
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0" savedVariablesVersion="1.1" />
        <Author name="xyeppp" email="" />
        <Replaces name="EA_CurrentEventsWindow" />
        <Description text="This module the current events window" />
        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_ParchmentWindowSkin" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
        </Dependencies>
        <Files>
            <File name="Original/Source/CurrentEventsWindow.xml" />
            <File name="Original/Source/CurrentEventDefs.lua" />
            <File name="Original/Source/CurrentEventsWindow.lua" />

            <File name="Core.lua" />
            <File name="Button.lua" />
            <File name="Templates.xml" />
            <File name="Window.xml" />
        </Files>

        <OnInitialize>
            <CreateWindow name="warExtendedWarReport" show="false"/>
            <CreateWindow name="EA_Window_CurrentEvents" show="false"/>
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="EA_Window_CurrentEvents.Settings" />
            <SavedVariable name="warExtendedWarReport.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>