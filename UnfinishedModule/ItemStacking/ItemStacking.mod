<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
    <UiMod name="warExtended Item Stacking" version="1.4" date="29/06/2021" >
        <VersionSettings gameVersion="1.4.9" windowsVersion="1.1" savedVariablesVersion="1.3"/>
      <Replaces name="EA_ItemStackingWindow" />
        <Description text="Enables buying of more than 100 items at a time and adds a slider to the buy/split item window."/>
        <Author name="xyeppp" email="" />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="warExtended Money Frame" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EA_Cursor" />
        </Dependencies>

        <Files>
            <File name="Core.lua" />
            <File name="Utils.lua" />
            <File name="Window.lua" />

            <File name="Original/Source/ItemStackingWindow.lua" />
            <File name="Original/Source/ItemStackingWindow.xml" />
        </Files>

        <OnInitialize>
            <CreateWindow name="ItemStackingWindow" show="false" />
            <CallFunction name="warExtendedItemStacking.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedItemStacking.history" />
        </SavedVariables>

        </UiMod>

</ModuleFile>
