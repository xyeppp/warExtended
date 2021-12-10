<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended" version="1.6" date="14/09/21">
    <VersionSettings gameVersion="1.4.8" windowsVersion="1.0" savedVariablesVersion="1.6" />
    <Author name="xyeppp" />
    <Description text="Addon framework designed to bring QoL improvements to Warhammer Online." />

        <Files>
            <File name="Core.lua" />
            <File name="Events.lua" />
            <File name="Flags.lua" />
            <File name="Globals.lua" />
            <File name="Hooks.lua" />
            <File name="Hyperlinks.lua" />
            <File name="Keymap.lua" />
            <File name="Slash.lua" />
            <File name="StateMachine.lua" />

            <!-- <File name="Options/Options.lua" />
            <File name="Options/Options.xml" />
            <File name="Options/OptionTemplates.xml" />-->


            <File name="Utils/AbilityData/Core.lua" />

            <!--Dark Elf-->
            <File name="Utils/AbilityData/Blackguard.lua" />
            <File name="Utils/AbilityData/DiscipleOfKhaine.lua" />
            <File name="Utils/AbilityData/Sorcerer.lua" />
            <File name="Utils/AbilityData/WitchElf.lua" />
            <!-- Chaos -->
            <File name="Utils/AbilityData/Zealot.lua" />
            <File name="Utils/AbilityData/Magus.lua" />
            <File name="Utils/AbilityData/Marauder.lua" />
            <File name="Utils/AbilityData/Chosen.lua" />

            <!--Greenskin-->
            <File name="Utils/AbilityData/BlackOrc.lua" />
            <File name="Utils/AbilityData/SquigHerder.lua" />
            <File name="Utils/AbilityData/Choppa.lua" />
            <File name="Utils/AbilityData/Shaman.lua" />

            <!--High Elf-->
            <File name="Utils/AbilityData/SwordMaster.lua" />
            <File name="Utils/AbilityData/Archmage.lua" />
            <File name="Utils/AbilityData/WhiteLion.lua" />
            <File name="Utils/AbilityData/ShadowWarrior.lua" />
            <!--Empire-->
            <File name="Utils/AbilityData/KnightOfTheBlazingSun.lua" />
            <File name="Utils/AbilityData/BrightWizard.lua" />
            <File name="Utils/AbilityData/WarriorPriest.lua" />
            <File name="Utils/AbilityData/WitchHunter.lua" />

            <!--Dwarf-->
            <File name="Utils/AbilityData/Engineer.lua" />
            <File name="Utils/AbilityData/RunePriest.lua" />
            <File name="Utils/AbilityData/Slayer.lua" />
            <File name="Utils/AbilityData/IronBreaker.lua" />

            <File name="Utils/Chat.lua" />
            <File name="Utils/General.lua" />
            <File name="Utils/Group.lua" />
            <File name="Utils/Target.lua" />
            <File name="Utils/Career.lua" />
            <File name="Utils/Macro.lua" />
            <File name="Utils/Button.lua" />
            <File name="Utils/Window.lua" />
            <File name="Utils/Icon.lua" />
            <File name="Utils/Search.lua" />
            <File name="Utils/Combat.lua" />
            <!--<File name="Utils/BackpackUtils.lua" />-->
          </Files>

       <OnInitialize>
           <!--<CreateWindow name="warExtendedOptions" show="false" />
           <CallFunction name="warExtended.InitializeOptions" />
            <CallFunction name="warExtended.Initialize" />-->
        </OnInitialize>

        <!--<OnShutdown>
            <CallFunction name="warExtended.OnShutdown" />
        </OnShutdown>-->

        <SavedVariables>
            <!--<SavedVariable name="warExtended.Settings" />-->
        </SavedVariables>
    </UiMod>
</ModuleFile>
