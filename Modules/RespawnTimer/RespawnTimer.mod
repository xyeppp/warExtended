<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<UiMod name="warExtended Respawn Timer" version="1.0" date="23/08/2023" >
		<Author name="xyeppp" email="xyeppp@gmail.com" />
		<Description text="Replaces the default respawn timer window." />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0" savedVariablesVersion="1.0" />
        <Dependencies>
            <Dependency name="warExtended" />
			<Dependency name="EA_GuildWindow" />
        </Dependencies>

		<Files>
            <File name="Window.xml" />
			<File name="Window.lua" />
		</Files>

		<OnInitialize/>
		<OnShutdown/>
	</UiMod>
</ModuleFile>
