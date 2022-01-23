<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Death Window" version="1.0" date="11/6/2007" >
        <Author name="xyeppp" email="" />
        <Replaces name="EA_DeathWindow" />
        <Description text="This module contains the EA Default Death Window." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
        </Dependencies>

        <Files>
            <File name="Core.lua" />
            <File name="Utils.lua" />
            <File name="Window.lua" />
            <File name="Template.xml" />
            <File name="Window.xml" />

            <File name="Textures/EA_Death01_d5.xml" />
            <File name="Source/DeathWindow.xml" />
        </Files>

        <OnInitialize>
            <CreateWindow name="DeathWindow" show="false" />
            <CreateWindow name="warExtendedDeathRecap" show="false" />

            <CallFunction name="warExtendedDeathWindow.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedDeathWindow.Settings" />
        </SavedVariables>

    </UiMod>

</ModuleFile>