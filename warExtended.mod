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
