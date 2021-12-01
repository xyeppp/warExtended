<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Screen Flash" version="1.0" date="23/11/2021" >
        <Author name="xyeppp" email="" />
        <Description text="This module contains an overlay image that will flash at the edges of your screen when you take damage." />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
         <Replaces name="EA_ScreenFlashWindow" />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Original/Textures/ScreenFlashTextures.xml" />
            <File name="Original/Source/ScreenFlashWindow.xml" />
            <File name="Original/Source/ScreenFlashWindow.lua" />



            <File name="Utils.lua" />
            <File name="Core.lua" />
            <File name="Button.lua" />
            <File name="Button.xml" />
        </Files>

        <OnInitialize>
            <CreateWindow name="ScreenFlashWindow" show="false" />
            <CallFunction name="warExtendedScreenFlash.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedScreenFlash.Settings" />
        </SavedVariables>
    </UiMod>
    
</ModuleFile>    