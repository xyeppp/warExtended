<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Bag Bonus" version="1.1" date="17/08/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
        <Description text="warExtended Bag Bonus Window module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="BagBonus.lua"  />
            <File name="BagBonus.xml"  />
        </Files>

        <OnInitialize>
            <CreateWindow name="BagBonusWindow" show="false" />
            <CallFunction name="warExtendedBagBonus.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedBagBonus.isInitialBagBonusCached" />
            <SavedVariable name="warExtendedBagBonus.BagBonuses" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
