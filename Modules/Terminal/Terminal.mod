<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended Terminal" version="2.0" date="21/10/22">
        <Replaces name="EA_UiDebugTools"/>
        <VersionSettings gameVersion="1.4.9" windowsVersion="1.0" savedVariablesVersion="1.3"/>
        <Author name="xyeppp" email=""/>
        <Description
                text="Overhauls the default debug window into a more terminal-like experience & adds tools aiding add-on development and debugging."/>
        <Dependencies>
            <Dependency name="EATemplate_DefaultWindowSkin" />
        </Dependencies>

        <Files>
          <!--  <File name="Functions.lua"/>-->
            <File name="Debug.lua"/>
            <File name="Core.lua"/>
            <File name="Window.lua"/>
            <File name="Options.lua"/>
            <File name="Utils.lua"/>
            <File name="Window.xml"/>

            <!--<File name="VerticalScroll.xml"/>
           -->
                     <!--      -->
        </Files>

        <OnInitialize>
            <CreateWindow name="DebugWindow" show="false"/>
            <CallFunction name="warExtendedTerminal.OnInitialize"/>
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedTerminal.Settings"/>
        </SavedVariables>

    </UiMod>

</ModuleFile>