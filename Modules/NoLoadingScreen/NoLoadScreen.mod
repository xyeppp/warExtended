<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended NoLoadingScreen" version="1.0" date="31/07/2023" >
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" />
        <Description text="This module removes loading screens in scenario/city when respawning or using the flag - optionally disables the loading screen on login." />
        <Replaces name="EA_LoadingScreen"/>
        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="LibSlash" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EATemplate_ParchmentWindowSkin" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EA_ScenarioSummaryWindow" />
        </Dependencies>
        <Files>
            <File name="Original/Textures/Textures.xml" />
            <File name="Original/Source/GeneralLoadingScreenTemplates.xml" />
            <File name="Original/Source/StandardLoadingScreenTemplate.xml" />
            <File name="Original/Source/ScenarioEnterLoadingScreenTemplate.xml" />
            <File name="Original/Source/ScenarioExitLoadingScreenTemplate.xml" />
            <File name="Original/Source/NoDataLoadingScreenTemplate.xml" />
            <File name="Original/Source/PatchNotesLoadingScreenTemplate.xml" />
            <File name="Original/Source/LoadingScreen.xml" />

            <File name="Core.lua" />
        </Files>

        <OnInitialize>
            <CreateWindow name="EA_Window_LoadingScreen" show="false" />
        </OnInitialize>

        <SavedVariables>
            <SavedVariable name="warExtendedNoLoadScreen.Settings" />
        </SavedVariables>
    </UiMod>

</ModuleFile>