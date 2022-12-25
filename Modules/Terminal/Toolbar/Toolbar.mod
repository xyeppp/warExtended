<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended Terminal Toolbar" version="2.0" date="21/10/22">
        <VersionSettings gameVersion="1.4.9" windowsVersion="1.0" savedVariablesVersion="1.2"/>
        <Author name="xyeppp" email=""/>
        <Description
                text="Adds a set of development tools to the Debug Window/Terminal."/>
        <Dependencies>
            <Dependency name="warExtended Terminal"/>
            <Dependency name="warExtended"/>
        </Dependencies>

        <Files>
            <File name="Window.xml"/>
            <File name="Core.lua"/>

            <File name="Tools/TooltipSpy/Window.xml"/>
            <File name="Tools/TooltipSpy/Core.lua"/>
            <File name="Tools/TooltipSpy/Window.lua"/>

            <File name="Tools/AreaViewer/Window.xml"/>
            <File name="Tools/AreaViewer/Core.lua"/>
            <File name="Tools/AreaViewer/Window.lua"/>

            <File name="Tools/AbilityFinder/Window.xml"/>
            <File name="Tools/AbilityFinder/Core.lua"/>
            <File name="Tools/AbilityFinder/Window.lua"/>

            <File name="Tools/CareerCacher/Window.xml"/>
            <File name="Tools/CareerCacher/Core.lua"/>
            <File name="Tools/CareerCacher/Window.lua"/>

            <File name="Tools/Logviewer/Window.xml"/>
            <File name="Tools/Logviewer/Core.lua"/>
            <File name="Tools/Logviewer/Window.lua"/>


            <File name="Tools/TextureViewer/Window.xml"/>
            <File name="Tools/TextureViewer/Core.lua"/>
            <File name="Tools/TextureViewer/Icons.lua"/>
            <File name="Tools/TextureViewer/Textures.lua"/>
            <File name="Tools/TextureViewer/Window.lua"/>


            <!--

             <File name="Tools/TextureViewer/Core.lua"/>
             <File name="Tools/TextureViewer/Window.lua"/>
             <File name="Tools/TextureViewer/Window.xml"/>
             <File name="Tools/DevPad/Core.lua"/>
             <File name="Tools/DevPad/Window.lua"/>
             <File name="Tools/DevPad/Window.xml"/>
             <File name="Tools/DevPad/debugwindowcodepad.lua"/>

             <File name="Tools/WindowHelper/Core.lua"/>
             <File name="Tools/WindowHelper/Window.lua"/>
             <File name="Tools/WindowHelper/Window.xml"/>
             <File name="Tools/WindowHelper/Highlighter.lua"/>
             <File name="Tools/WindowHelper/Highlighter.xml"/>

             <File name="Tools/Logdump/Core.lua"/>
             <File name="Tools/Logdump/Window.lua"/>
             <File name="Tools/Logdump/Window.xml"/>

             <File name="Tools/EventSpy/Core.lua"/>
             <File name="Tools/EventSpy/Window.lua"/>
             <File name="Tools/EventSpy/Window.xml"/>


            <!-
               <File name="Tools/DebugLog/Interceptor.lua"/>
             <File name="Tools/DebugLog/Core.lua"/>
             <File name="Tools/DebugLog/Window.lua"/>
             <File name="Tools/DebugLog/Window.xml"/>
            <File name="Tools/DebugLog/Busted.lua"/>
             <File name="Tools/DebugLog/Busted.xml"/>-->



            <!--<File name="VerticalScroll.xml"/>
            <File name="Window.xml"/>-->

            <!--<File name="Utils.lua"/>
            <File name="Options.lua"/>
            <File name="Window.lua"/>
           <File name="Commands.lua"/>-->


            <!--          <File name="Tools/Busted/Busted.lua"/>

               <File name="Tools/CareerCacher/CareerCacher.lua"/>

               <File name="Tools/ObjectInspector/ObjectInspector.lua"/>
               <File name="Tools/ObjectInspector/ObjectInspector.xml"/>

               <File name="Tools/Timer/Timer.lua"/>
               <File name="Tools/Timer/Timer.xml"/>

               <File name="Tools/WindowHighlight/WindowHighlight.lua"/>-->
        </Files>

        <OnInitialize>
            <CreateWindow name="DebugWindowToolbar" show="false"/>
            <CallFunction name="TerminalToolbar.OnInitialize"/>
        </OnInitialize>
    </UiMod>

</ModuleFile>