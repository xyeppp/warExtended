<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended" version="0.4" date="21/10/22">
        <VersionSettings gameVersion="1.4.8"/>
        <Author name="xyeppp"/>
        <Description
                text="Addon framework for all warExtended addons designed to bring Quality of Life improvements and more to Warhammer Online: Return of Reckoning."/>
        <Dependencies>
            <Dependency name="EASystem_WindowUtils"/>
            <Dependency name="EA_ActionBars"/>
        </Dependencies>
        <Files>
            <File name="Core.lua"/>
            <File name="Buttons.lua"/>
            <File name="Sets.lua"/>

            <File name="Utils/General.lua"/>
            <File name="Utils/Id.lua"/>
            <File name="Utils/Mouse.lua"/>
            <!-- <File name="Utils/Search.lua"/>-->
            <File name="Utils/String.lua"/>
            <File name="Utils/Table.lua"/>
            <File name="Utils/Time.lua"/>

            <File name="Chat.lua"/>
            <File name="LinkedList.lua"/>
            <File name="StateMachine.lua"/>
            <File name="Events.lua"/>
            <File name="Emotes.lua"/>
            <File name="Flags.lua"/>
            <File name="GameEvents.lua"/>
            <File name="Globals.lua"/>
            <File name="Hooks.lua"/>
            <File name="Hyperlinks.lua"/>
            <File name="Keymap.lua"/>
            <File name="Slash.lua"/>
            <File name="TableSerializator.lua"/>

            <File name="Textures/Textures.xml"/>

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

            <File name="Frames/AnimatedImage/AnimatedImage.lua"/>

            <File name="Frames/SliderBar/SliderBar.xml"/>
            <File name="Frames/SliderBar/SliderBar.lua"/>

            <File name="Frames/VerticalScrollbar/VerticalScrollbar.xml"/>
            <File name="Frames/VerticalScrollbar/VerticalScrollbar.lua"/>

            <File name="Frames/Button/ButtonFrame.xml"/>
            <File name="Frames/Button/ButtonFrame.lua"/>

            <File name="Frames/IconButton/IconButton.xml"/>
            <File name="Frames/IconButton/IconButton.lua"/>

            <File name="Frames/CircleImage/CircleImage.xml"/>
            <File name="Frames/CircleImage/CircleImage.lua"/>

            <File name="Frames/ColorPicker/ColorPicker.xml"/>
            <File name="Frames/ColorPicker/ColorPicker.lua"/>

            <File name="Frames/ColorSliders/ColorSliders.xml"/>
            <File name="Frames/ColorSliders/ColorSliders.lua"/>

            <File name="Frames/ComboBox/ComboBox.xml"/>
            <File name="Frames/ComboBox/ComboBox.lua"/>

            <File name="Frames/ContextMenu/ContextMenu.lua"/>
            <File name="Frames/ContextMenu/FontContextMenu.lua"/>
          <!--  <File name="Frames/ContextMenu/ContextMenu.xml"/>-->

            <File name="Frames/Dialog/Dialogs.xml"/>
            <File name="Frames/Dialog/Dialogs.lua"/>

            <File name="Frames/DynamicImage/DynamicImage.lua"/>

            <File name="Frames/Frame/Frame.lua"/>
            <File name="Frames/FrameManager/FrameManager.lua"/>

            <File name="Frames/ExperienceBar/ExperienceBar.xml"/>
            <File name="Frames/ExperienceBar/ExperienceBar.lua"/>

            <File name="Frames/HorizontalScrollbar/HorizontalScrollbar.lua"/>

            <File name="Frames/HorizontalScrollWindow/HorizontalScrollWindow.lua"/>

            <File name="Frames/Images/Images.xml"/>

            <!--<File name="Frames/IncrementButtons/IncrementButtons.lua"/>
            <File name="Frames/IncrementButtons/IncrementButtons.xml"/>-->

            <File name="Frames/Label/Label.xml"/>

            <File name="Frames/ListBox/ListBox.xml"/>
            <File name="Frames/ListBox/ListBox.lua"/>

            <File name="Frames/ExpandableListBox/ExpandableListBox.xml"/>
            <File name="Frames/ExpandableListBox/ExpandableListBox.lua"/>

            <File name="Frames/LogDisplay/LogDisplay.lua"/>

            <File name="Frames/RadioGroup/RadioGroup.lua"/>

            <File name="Frames/RenownBar/RenownBar.xml"/>
            <File name="Frames/RenownBar/RenownBar.lua"/>

            <File name="Frames/ScrollWindow/ScrollWindow.xml"/>
            <File name="Frames/ScrollWindow/ScrollWindow.lua"/>

            <File name="Frames/IconScrollWindow/IconScrollWindow.lua"/>

            <File name="Frames/SearchBox/SearchBox.xml"/>
            <File name="Frames/SearchBox/SearchBox.lua"/>

            <File name="Frames/Sets/Sets.xml"/>
            <File name="Frames/Sets/Sets.lua"/>

            <File name="Frames/SimpleCheckButton/SimpleCheckButton.xml"/>
            <File name="Frames/SimpleCheckButton/SimpleCheckButton.lua"/>

            <File name="Frames/StatusBar/StatusBar.lua"/>

            <File name="Frames/TabGroup/TabGroup.xml"/>
            <File name="Frames/TabGroup/TabGroup.lua"/>

          <!--  <File name="Frames/TabManager/TabManager.xml"/>
            <File name="Frames/TabManager/TabManager.lua"/>-->

            <File name="Frames/TextEditBox/TextEditBox.xml"/>
            <File name="Frames/TextEditBox/TextEditBox.lua"/>

            <File name="Frames/TextLog/TextLog.lua"/>

            <File name="Frames/Tooltips/Tooltips.lua"/>

            <File name="Frames/Window/Window.xml"/>

            <File name="Frames/WindowUtils/WindowUtils.lua"/>

            <File name="Settings/Templates.xml"/>
            <File name="Settings/Window.xml"/>
            <File name="Settings/Core.lua"/>
            <File name="Settings/Test.lua"/>
            <File name="Settings/Window.lua"/>
        </Files>

        <OnInitialize>
            <CallFunction name="warExtended.Initialize"/>
        </OnInitialize>
    </UiMod>
</ModuleFile>
