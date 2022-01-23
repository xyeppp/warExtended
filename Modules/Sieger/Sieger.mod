<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Siege Chat" version="1.0" date="18/01/22" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.0" />
        <Description text="Tweaks the chat window whilst using a siege weapon to match the main chat window look and filters." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EA_SiegeWeaponWindow" />
        </Dependencies>

        <Files>
            <File name="Core.lua"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedSieger.OnInitialize" />
        </OnInitialize>

        <OnShutdown>
        </OnShutdown>

        <SavedVariables>
        </SavedVariables>
    </UiMod>

</ModuleFile>
