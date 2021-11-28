<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Hotbar Switcher" version="1.0" date="22/09/21" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.3" />
        <Description text="warExtended Hotbar Switcher module." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EASystem_ActionBarClusterManager" />
            <Dependency name="EA_ActionBars" />
        </Dependencies>

        <Files>
            <File name="Core.lua"  />
            <File name="Utils.lua" />
        </Files>

         <OnInitialize>
             <CallFunction name="warExtendedHotbarSwitcher.OnInitialize" />
         </OnInitialize>

         <SavedVariables>
             <SavedVariable name="warExtendedHotbarSwitcher.Switchers" />
         </SavedVariables>
    </UiMod>

</ModuleFile>
