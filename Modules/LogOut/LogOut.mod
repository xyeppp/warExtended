<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
    <UiMod name="warExtended LogOut" version="1.0" date="24/07/23" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" />
        <Description text="Adds a visual feedback window to the logout process." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EA_ScreenFlashWindow" />
        </Dependencies>

        <Files>
            <File name="Window.xml"  />
        </Files>

        <OnInitialize>
            <CreateWindow name="warExtendedLogOutWindow" show="false" />
        </OnInitialize>
    </UiMod>

</ModuleFile>