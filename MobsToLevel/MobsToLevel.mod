<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Mobs2Level" version="1.1" date="17/08/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.4" />
        <Description text="warExtended Mobs2Level." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="MobsToLevel.lua"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedM2L.OnInitialize" />
        </OnInitialize>

         <SavedVariables>
            <SavedVariable name="warExtendedM2L.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
