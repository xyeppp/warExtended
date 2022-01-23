<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended" version="1.6" date="14/09/21">
    <VersionSettings gameVersion="1.4.8" windowsVersion="1.0" savedVariablesVersion="1.6" />
    <Author name="xyeppp" />
    <Description text="Addon framework designed to bring QoL improvements to Warhammer Online." />
        <Files>
            <File name="Libs/LibStub/LibStub.lua" />
            <File name="Libs/CustomSearch/CustomSearch-1.0.lua" />

            <File name="Core.lua" />
            <File name="Events.lua" />
            <File name="Flags.lua" />
            <File name="Globals.lua" />
            <File name="Hooks.lua" />
            <File name="Hyperlinks.lua" />
            <File name="Keymap.lua" />
            <File name="Slash.lua" />
            <File name="Search.lua" />
            <File name="StateMachine.lua" />

            <File name="Options/Templates.xml" />
            <File name="Options/Core.lua" />
            <File name="Options/Utils.lua" />
            <File name="Options/Window.lua" />
            <File name="Options/Window.xml" />


            <File name="Utils/Addons.lua" />
            <File name="Utils/Career.lua" />
            <File name="Utils/Chat.lua" />
            <File name="Utils/General.lua" />
            <File name="Utils/Group.lua" />
            <File name="Utils/Target.lua" />
            <File name="Utils/Macro.lua" />
            <File name="Utils/Window.lua" />
            <File name="Utils/Icon.lua" />
            <File name="Utils/Player.lua" />
            <File name="Utils/Combat.lua" />
            <!--<File name="Utils/BackpackUtils.lua" />-->
          </Files>

       <OnInitialize>
           <CreateWindow name="warExtendedOptionsWindow" show="false" />
           <!-- <CallFunction name="warExtended.Initialize" />-->
        </OnInitialize>

        <!--<OnShutdown>
            <CallFunction name="warExtended.OnShutdown" />
        </OnShutdown>-->

        <SavedVariables>
            <!--<SavedVariable name="warExtended.Settings" />-->
        </SavedVariables>
    </UiMod>
</ModuleFile>
