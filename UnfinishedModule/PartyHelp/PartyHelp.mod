<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Party Helper" version="1.0" date="17/08/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.0" />
        <Description text="warExtended Party Helper module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="PartyHelp.lua"  />
            <File name="PartyHelp.xml" />
        </Files>

       <OnInitialize>
           <CreateWindow name="PartyHelpWindow" show="false" />
           <CreateWindow name="PartyHelpWindowCloseButton" show="false" />
           <CallFunction name="warExtendedPartyHelper.OnInitialize" />
         </OnInitialize>

         <!--<SavedVariables>
             <SavedVariable name="warExtendedNameActions.QuickMessages" />
         </SavedVariables>-->
    </UiMod>

</ModuleFile>
