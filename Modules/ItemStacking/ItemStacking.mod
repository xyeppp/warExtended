<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
    <UiMod name="warExtended Item Stacking" version="1.0" date="09/06/23" >
        <VersionSettings gameVersion="1.4.9" windowsVersion="1.1" savedVariablesVersion="1.0"/>
        <Replaces name="EA_ItemStackingWindow" />
        <Description text="Enables buying of more than 100 items at a time, adds a slider to the buy/split item window and displays total cost of purchases."/>
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EASystem_Tooltips" />
            <Dependency name="EA_Cursor" />
        </Dependencies>

        <Files>
            <File name="Window.xml" />
        </Files>

        <OnInitialize>
            <CreateWindow name="ItemStackingWindow" show="false" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="ItemStackingWindow.history" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
