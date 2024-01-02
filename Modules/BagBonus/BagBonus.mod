<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Bag Bonus" version="1.0" date="14/06/23" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="2.0" />
        <Description text="Adds a visual representation for the current accumulated bag bonus." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Window.xml"  />
            <File name="Core.lua"  />
            <File name="Window.lua"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedBagBonus.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedBagBonus.Settings"/>
        </SavedVariables>
    </UiMod>

</ModuleFile>
