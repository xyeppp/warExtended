<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Bag Bonus" version="1.2" date="17/08/21" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.2" />
        <Description text="warExtended Bag Bonus Window module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Core.lua"  />
            <File name="Utils.lua"  />
            <File name="Window.lua"  />
            <File name="Slash.lua"  />
            <File name="Window.xml"  />
        </Files>

        <OnInitialize>
            <CreateWindow name="BagBonusWindow" show="false" />
            <CallFunction name="warExtendedBagBonus.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedBagBonus.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
