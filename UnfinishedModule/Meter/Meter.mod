<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Meter" version="1.0" date="22/09/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.0" />
        <Description text="warExtended Meter module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Meter.lua"  />
            <File name="Meter.xml"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedMeter.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedMeter.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
