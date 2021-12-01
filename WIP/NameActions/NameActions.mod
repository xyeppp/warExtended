<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended NameActions" version="1.0" date="17/08/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.0" />
        <Description text="warExtended NameActions module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="NameActions.lua"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedNameActions.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedNameActions.QuickMessages" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
