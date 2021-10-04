<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <UiMod name="warExtended StopRes" version="1.0.0" date="30/09/21" >
    <VersionSettings gameVersion="1.9.9" windowsVersion="1.0" savedVariablesVersion="1.0" />
    <Author name="xyeppp" email="" />
    <Description text="warExtended StopRes module." />
    <Dependencies>
      <Dependency name="warExtended" />
      <Dependency name="EA_CastTimerWindow" />
    </Dependencies>
    <Files>
      <File name="StopRes.lua" />
    </Files>
      <OnInitialize>
      <CallFunction name="warExtendedStopRes.OnInitialize" />
    </OnInitialize>
	<OnShutdown>
	<CallFunction name="warExtendedStopRes.OnShutdown" />
	</OnShutdown>
	<SavedVariables>
	<SavedVariable name="warExtendedStopRes.Settings" />
	</SavedVariables>
    <WARInfo>
    </WARInfo>
  </UiMod>
</ModuleFile>
