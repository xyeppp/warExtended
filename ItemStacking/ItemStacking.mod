<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
    <UiMod name="warExtended Item Stacking" version="1.3" date="29/06/2021" >
        <VersionSettings gameVersion="1.4.9" windowsVersion="1.1"/>
      <Replaces name="EA_ItemStackingWindow" />
        <Author name="xyeppp" email="" />
        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EASystem_Tooltips" />
            <Dependency name="EA_Cursor" />
        </Dependencies>
        <Files>
            <File name="Source/ItemStackingWindow.xml" />
            <File name="ItemStackingWindow.lua" />
        </Files>
        <OnInitialize>
            <CreateWindow name="ItemStackingWindow" show="false" />
        </OnInitialize>
        <SavedVariables>
            <SavedVariable name="warExtendedItemStacking.history" />
        </SavedVariables>
        </UiMod>

</ModuleFile>
