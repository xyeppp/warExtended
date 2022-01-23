<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended StopRes" version="1.3" date="18/01/22" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.0" />
        <Description text="A small addon for healers that automatically cancels a ressurection if the current target has been ressurected while casting." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EA_CastTimerWindow" />
        </Dependencies>

        <Files>
            <File name="Core.lua"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedStopRes.OnInitialize" />
        </OnInitialize>

        <OnShutdown>
            <CallFunction name="warExtendedStopRes.OnShutdown" />
        </OnShutdown>

        <SavedVariables>
            <SavedVariable name="warExtendedStopRes.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
