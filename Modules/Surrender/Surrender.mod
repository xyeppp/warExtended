<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <UiMod name="warExtended Surrender Vote" version="1.0" date="31/07/2023">
        <Author name="xyeppp" email="xyeppp@gmail.com" />
        <Description text="This module replaces the default RoR Scenario Surrender module." />
        <Replaces name="RoR_ScenarioSurrenderWindow"/>

		<Dependencies>
			<Dependency name="warExtended" />
			<Dependency name="EA_ChatWindow" />
			<Dependency name="EA_ScenarioGroupWindow" />
			<Dependency name="EASystem_LayoutEditor" />
		</Dependencies>

    	<Files>
		<File name="Window.xml" />
		</Files>

	   <OnInitialize>
		   <CreateWindow name="warExtendedSurrenderVote" show="false" />
        </OnInitialize>

    </UiMod>
</ModuleFile>
