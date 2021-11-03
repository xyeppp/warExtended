        <?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Sieger" version="1.0" date="30/09/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.1" />
        <Description text="warExtended Sieger module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Sieger.lua"  />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedSieger.OnInitialize" />
        </OnInitialize>

        <!--<OnShutdown>
            <CallFunction name="warExtendedSieger.OnShutdown" />
        </OnShutdown>

        <SavedVariables>
            <SavedVariable name="warExtendedSieger.Settings" />
        </SavedVariables>-->
    </UiMod>

</ModuleFile>
