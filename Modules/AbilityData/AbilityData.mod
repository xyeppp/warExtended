<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Abilities Data" version="1.2" date="17/08/21" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.2" />
        <Description text="This addon contains the full ability data definition for all classes - needed as a dependency for a few other modules." />
        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Core.lua" />

            <File name="DarkElf/Blackguard.lua" />
            <File name="DarkElf/DiscipleOfKhaine.lua" />
            <File name="DarkElf/Sorcerer.lua" />
            <File name="DarkElf/WitchElf.lua" />

            <File name="Chaos/Zealot.lua" />
            <File name="Chaos/Magus.lua" />
            <File name="Chaos/Marauder.lua" />
            <File name="Chaos/Chosen.lua" />

            <File name="Greenskin/BlackOrc.lua" />
            <File name="Greenskin/SquigHerder.lua" />
            <File name="Greenskin/Choppa.lua" />
            <File name="Greenskin/Shaman.lua" />

            <File name="HighElf/SwordMaster.lua" />
            <File name="HighElf/Archmage.lua" />
            <File name="HighElf/WhiteLion.lua" />
            <File name="HighElf/ShadowWarrior.lua" />

            <File name="Empire/KnightOfTheBlazingSun.lua" />
            <File name="Empire/BrightWizard.lua" />
            <File name="Empire/WarriorPriest.lua" />
            <File name="Empire/WitchHunter.lua" />

            <File name="Dwarf/Engineer.lua" />
            <File name="Dwarf/RunePriest.lua" />
            <File name="Dwarf/Slayer.lua" />
            <File name="Dwarf/IronBreaker.lua" />
        </Files>

        <OnInitialize>
        </OnInitialize>

        <SavedVariables>
        </SavedVariables>
    </UiMod>

</ModuleFile>
