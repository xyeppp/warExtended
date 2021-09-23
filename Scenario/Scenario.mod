<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Scenario" version="1.0" date="17/08/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.0" />
        <Description text="warExtended Scenario module." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EA_ObjectiveTrackers" />
        </Dependencies>

        <Files>
            <File name="Scenario.lua"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedScenario.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedScenario.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
