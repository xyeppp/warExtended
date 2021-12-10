<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Mirage" version="1.1" date="30/09/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
        <Description text="warExtended Mirage module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Core.lua"  />
            <File name="Window.lua" />
            <File name="Slash.lua" />
            <File name="Buttons.lua"  />
            <File name="ListBox.lua" />
            <File name="Utils.lua" />

            <File name="Template.xml" />
            <File name="Window.xml" />
        </Files>

        <OnInitialize>
            <CreateWindow name="warExtendedMirage" show="false"/>
            <CreateWindow name="warExtendedMirageAttache" show="true"/>
            <CallFunction name="warExtendedMirage.OnInitialize"/>
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedMirage.Sets" />
        </SavedVariables>

    </UiMod>
</ModuleFile>
