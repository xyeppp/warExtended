<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Macros Plus" version="1.0" date="27/08/23" >
        <Replaces name="EA_MacroWindow" />
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
        <Description text="This module replaces the default EA_MacroWindow adding additional macro sets, more icons for selection and expands the window in size." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="LibSlash" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EA_LegacyTemplates" />
        </Dependencies>

        <Files>
            <File name="Window.xml"  />
        </Files>

        <OnInitialize>
            <CreateWindow name="warExtendedMacroPlusWindowIconSelection" show="false" />
            <CreateWindow name="warExtendedMacroPlusWindow" show="false" />

            <CallFunction name="warExtendedMacroPlus.OnInitialize"/>
        </OnInitialize>

           <SavedVariables>
            <SavedVariable name="warExtendedMacroPlus.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
