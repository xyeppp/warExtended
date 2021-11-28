 <?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Screen Flash " version="1.1" date="05/10/21" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
        <Description text="warExtended Screen Flash  module." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EA_ScreenFlashWindow" />
        </Dependencies>

        <Files>
            <File name="ScreenFlash.lua"  />
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

