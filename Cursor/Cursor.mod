<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Cursor" version="1.1" date="17/08/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
        <Description text="warExtended Cursor module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Cursor.lua"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedCursor.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedCursor.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
