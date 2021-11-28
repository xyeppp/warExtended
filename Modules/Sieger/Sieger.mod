<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Siege" version="1.0" date="30/09/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
        <Description text="warExtended Siege module." />

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
