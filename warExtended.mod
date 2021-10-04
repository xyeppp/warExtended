<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <UiMod name="warExtended" version="1.6" date="14/09/21">
    <VersionSettings gameVersion="1.4.8" windowsVersion="1.0" savedVariablesVersion="1.6" />
    <Author name="xyeppp" />
    <Description text="warExtended is a combination of addons designed to bring Quality of Life improvements to Warhammer Online." />

        <Dependencies>
            <Dependency name="LibSlash"/>
        </Dependencies>

        <Files>
            <File name="Core.lua" />
            <File name="Hooks.lua" />
            <File name="StateMachine.lua" />
            <File name="Utils.lua" />
            <File name="GroupUtils.lua" />
           <!-- <File name="BackpackUtils.lua" /> -->
            <File name="Slash.lua" />
            <File name="Keymap.lua" />
            <File name="Events.lua" />
            <File name="Flags.lua" />
            <File name="Options.lua" />
            <File name="Options.xml" />
            <File name="OptionTemplates.xml" />
            <File name="Hyperlinks.lua" />
          </Files>

       <OnInitialize>
           <CreateWindow name="warExtendedOptions" show="false" />
           <CallFunction name="warExtended.InitializeOptions" />
          <!-- <CallFunction name="warExtended.Initialize" />-->
        </OnInitialize>

        <!--<OnShutdown>
            <CallFunction name="warExtended.OnShutdown" />
        </OnShutdown>-->

        <SavedVariables>
            <!--<SavedVariable name="warExtended.Settings" />-->
        </SavedVariables>
    </UiMod>
</ModuleFile>
