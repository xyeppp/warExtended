<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended" version="0.3" date="21/10/22">
        <VersionSettings gameVersion="1.4.8"/>
        <Author name="xyeppp"/>
        <Description
                text="Addon framework for all warExtended addons designed to bring Quality of Life improvements and more to Warhammer Online: Return of Reckoning."/>
        <Dependencies>
            <Dependency name="EASystem_WindowUtils"/>
        </Dependencies>
        <Files>
            <File name="Core.lua"/>
            <File name="Chat.lua"/>
            <File name="LinkedList.lua"/>
            <File name="Events.lua"/>
            <File name="Flags.lua"/>
            <File name="Globals.lua"/>
            <File name="Hooks.lua"/>
            <File name="Hyperlinks.lua"/>
            <File name="Keymap.lua"/>
            <File name="Sets.lua"/>
            <File name="Slash.lua"/>
            <File name="TableSerializator.lua"/>

            <File name="Utils/Game/Addons.lua"/>
            <File name="Utils/Game/Career.lua"/>
            <File name="Utils/Game/Combat.lua"/>
            <File name="Utils/Game/Constants.lua"/>
            <File name="Utils/Game/Group.lua"/>
            <File name="Utils/Game/Icons.lua"/>
            <File name="Utils/Game/Macro.lua"/>
            <File name="Utils/Game/Player.lua"/>
            <File name="Utils/Game/RORCommands.lua"/>
            <File name="Utils/Game/Sound.lua"/>
            <File name="Utils/Game/Target.lua"/>
            <File name="Utils/Game/Window.lua"/>

            <File name="Utils/General.lua"/>
            <File name="Utils/Id.lua"/>
            <!-- <File name="Utils/Search.lua"/>-->
            <File name="Utils/String.lua"/>
            <File name="Utils/Table.lua"/>
            <File name="Utils/Time.lua"/>

            <File name="Templates/Button/ButtonFrame.xml"/>
            <File name="Templates/Button/ButtonFrame.lua"/>

            <File name="Templates/CircleImage/CircleImage.xml"/>
            <File name="Templates/CircleImage/CircleImage.lua"/>

            <File name="Templates/ComboBox/ComboBox.xml"/>

            <File name="Templates/Dialog/Dialogs.xml"/>
            <File name="Templates/Dialog/Dialogs.lua"/>

            <File name="Templates/EditBox/EditBox.lua"/>
            <File name="Templates/EditBox/EditBox.xml"/>

            <File name="Templates/Frame/Frame.lua"/>
            <File name="Templates/FrameManager/FrameManager.lua"/>

            <File name="Templates/Images/Images.xml"/>
            <!--<File name="Templates/IncrementButtons/IncrementButtons.lua"/>
            <File name="Templates/IncrementButtons/IncrementButtons.xml"/>-->

            <File name="Templates/Label/Label.xml"/>

            <File name="Templates/ListBox/ListBox.xml"/>
            <File name="Templates/ListBox/ListBox.lua"/>

            <File name="Templates/LogDisplay/LogDisplay.lua"/>

            <File name="Templates/RadioGroup/RadioGroup.lua"/>

            <File name="Templates/SearchBox/SearchBox.xml"/>
            <File name="Templates/SearchBox/SearchBox.lua"/>

            <File name="Templates/ScrollWindow/ScrollWindow.lua"/>

            <File name="Templates/TextLog/TextLog.lua"/>

            <File name="Templates/SimpleCheckButton/SimpleCheckButton.lua"/>

            <File name="Templates/StatusBar/StatusBar.lua"/>

            <File name="Templates/TabGroup/TabGroup.lua"/>
            <File name="Templates/TabGroup/TabGroup.xml"/>

            <File name="Templates/Tooltips/Tooltips.lua"/>

            <File name="Templates/VerticalScrollbar/VerticalScrollbar.lua"/>

            <File name="Templates/Window/Window.xml"/>
        </Files>

        <OnInitialize>
            <CallFunction name="warExtended.Initialize"/>
        </OnInitialize>
    </UiMod>
</ModuleFile>
