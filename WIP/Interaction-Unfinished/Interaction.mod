<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Interaction" version="1.2" date="11/6/2007" >
        <VersionSettings gameVersion="1.4.9" windowsVersion="1.2" savedVariablesVersion="1.3"/>
        <Replaces name="EA_InteractionWindow" />
        <Author name="xyeppp" email="" />
        <Description text="warExtended Interaction module replacing default UI." />

        <Dependencies>
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EASystem_Tooltips" />
            <Dependency name="EASystem_Strings" />
            <Dependency name="EASystem_DialogManager" />
            <Dependency name="EASystem_ResourceFrames" />
            <Dependency name="EA_LegacyTemplates" />
            <Dependency name="EA_ContextMenu" />
            <Dependency name="EA_GuildWindow" />
            <Dependency name="EA_TomeOfKnowledge" />
            <Dependency name="EA_WorldMapWindow" />
            <Dependency name="EASystem_AdvancedWindowManager" />
        </Dependencies>

        <Files>
            <File name="Core.lua" />

            <File name="Store/Core.lua" />
            <File name="Store/Search.lua" />
            <File name="Store/Window.lua" />
            <File name="Store/Default.lua" />
            <File name="Store/Window.xml" />

            <File name="Original/Textures/TrainingTextures.xml" />
            <File name="Original/Textures/BaseTextures.xml" />

            <File name="Original/Source/Templates_InteractionVerticalScrollbar.xml" />
            <File name="Original/Source/Templates_InteractionBase.xml" />
            <File name="Original/Source/Templates_InteractionQuest.xml" />
            <File name="Original/Source/Templates_InteractionFlightMaster.xml" />
            <File name="Original/Source/Templates_InteractionTraining.xml" />

            <File name="Original/Source/InteractionUtils.lua" />
            <File name="Original/Source/InteractionBase.xml" />
            <File name="Original/Source/InteractionHealerWindow.xml" />
            <File name="Original/Source/InteractionQuestWindow.xml" />
            <File name="Original/Source/InteractionInfluenceRewards.xml" />
            <File name="Original/Source/InteractionEventRewards.lua" />
            <File name="Original/Source/InteractionEventRewards.xml" />

            <File name="Original/Source/InteractionFlightMaster.lua" />
            <File name="Original/Source/InteractionFlightMaster.xml" />
            <File name="Original/Source/InteractionTraining.lua" />
            <File name="Original/Source/InteractionCoreTraining.xml" />
            <File name="Original/Source/InteractionSpecialtyTraining.xml" />
            <File name="Original/Source/InteractionRenownTraining.xml" />
            <File name="Original/Source/InteractionTomeTraining.xml" />
            <File name="Original/Source/InteractionTradeskills.lua" />
            <File name="Original/Source/InteractionWindowGuildCreateForm.xml" />
            <File name="Original/Source/InteractionWindowGuildRename.xml" />
            <File name="Original/Source/InteractionWindowAltCurrency.lua" />
            <File name="Original/Source/InteractionWindowAltCurrency.xml" />
            <File name="Original/Source/InteractionWindowLibrarian.xml" />
            <File name="Original/Source/InteractionWindowLastName.xml" />
            <File name="Original/Source/InteractionKeepUpgrades.xml" />
            <File name="Original/Source/InteractionAltar.xml" />
        </Files>

        <OnInitialize>
            <CallFunction name="warExtendedInteraction.OnInitialize" />


            <CreateWindow name="EA_Window_InteractionStore" show="false" />



            <CreateWindow name="EA_Window_InteractionBase" show="false" />
            <CreateWindow name="EA_Window_InteractionHealer" show="false" />
            <CreateWindow name="EA_Window_InteractionQuest" show="false" />
            <CreateWindow name="EA_Window_InteractionInfluenceRewards" show="false" />
            <CreateWindow name="EA_Window_InteractionEventRewards" show="false" />
            <CreateWindow name="EA_Window_InteractionCoreTraining" show="false" />
            <CreateWindow name="EA_Window_InteractionSpecialtyTraining" show="false" />
            <CreateWindow name="EA_Window_InteractionRenownTraining" show="false" />
            <CreateWindow name="EA_Window_InteractionTomeTraining" show="false" />
            <CreateWindow name="EA_Window_InteractionKeepUpgrades" show="false" />
            <CreateWindow name="EA_Window_InteractionAltar" show="false" />
            <CreateWindow name="EA_InteractionFlightMasterWindow" show="false" />
            <CreateWindow name="InteractionWindowGuildCreateForm" show="false" />
            <CreateWindow name="InteractionWindowGuildRename" show="false" />
            <CreateWindow name="EA_Window_InteractionAltCurrency" show="false" />
            <CreateWindow name="EA_Window_InteractionLibrarianStore" show="false" />
            <CreateWindow name="EA_Window_InteractionLastName" show="false" />
            <CallFunction name="EA_Window_InteractionTraining.Initialize" />
        </OnInitialize>

        <OnShutdown>
            <CallFunction name="EA_Window_InteractionTraining.Shutdown" />
        </OnShutdown>

        <SavedVariables>
            <SavedVariable name="EA_Window_InteractionCoreTraining.Settings" />
            <SavedVariable name="EA_Window_InteractionTomeTraining.Settings" />
        </SavedVariables>

    </UiMod>

</ModuleFile>
