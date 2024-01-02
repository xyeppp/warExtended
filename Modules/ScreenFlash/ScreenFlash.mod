<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Screen Flash" version="1.0" date="31/07/23" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <Description text="This addon will slightly flash your screen when you take damage - the flash becomes stronger past certain HP thresholds." />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
         <Replaces name="EA_ScreenFlashWindow" />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Textures/ScreenFlashTextures.xml" />
            <File name="Window.xml" />
        </Files>

        <OnInitialize>
            <CreateWindow name="ScreenFlashWindow" show="false" />

            <CallFunction name="ScreenFlashWindow.OnInitialize" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="ScreenFlashWindow.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>
