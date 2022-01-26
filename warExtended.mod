<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended" version="0.1" date="25/01/22">
    <VersionSettings gameVersion="1.4.9" windowsVersion="1.0" savedVariablesVersion="1.0" />
    <Author name="xyeppp" />
    <Description text="Addon framework designed to bring Quality of Life improvements to Warhammer Online." />
        <Files>
            <File name="Libs/LibStub/LibStub.lua" />
            <File name="Libs/CustomSearch/CustomSearch-1.0.lua" />

            <File name="Core.lua" />
            <File name="Utils.lua" />
            <File name="LinkedList.lua" />
            <File name="ManagerList.lua" />
            <File name="Events.lua" />
            <File name="Flags.lua" />
            <File name="Globals.lua" />
            <File name="Hooks.lua" />
            <File name="Hyperlinks.lua" />
            <File name="Keymap.lua" />
            <File name="Chat.lua" />
            <File name="Slash.lua" />
            <File name="Search.lua" />
            <File name="StateMachine.lua" />
            <File name="Templates.xml" />

            <File name="Settings/Templates.xml" />
            <File name="Settings/ListBox.lua" />
            <File name="Settings/Core.lua" />
            <File name="Settings/Templates.lua" />
            <File name="Settings/ChildEntries.lua" />
            <File name="Settings/Window.lua" />
            <File name="Settings/Window.xml" />

            <File name="Utils/Addons.lua" />
            <File name="Utils/Career.lua" />
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
           <CreateWindow name="warExtendedSettings" show="false" />
           <CallFunction name="warExtended.Initialize" />
        </OnInitialize>

        <SavedVariables>
           <SavedVariable name="warExtendedSettings.Config" />
        </SavedVariables>
    </UiMod>
</ModuleFile>
