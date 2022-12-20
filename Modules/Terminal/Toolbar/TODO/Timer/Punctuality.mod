<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="DevBar_Punctuality" version="1.0" date="3/5/2008" autoenabled="false">
        <Author name="Nathan Bonfiglio" email="nbonfiglio@ea.com" />
        <Description text="A simple timer/stopwatch mod" />
        <Dependencies>        
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EA_UiDebugTools" />
            <Dependency name="DevBar" />
        </Dependencies>
        <Files>        
            <File name="Punctuality.xml" />
        </Files>
        <OnInitialize>
            <CallFunction name="Punctuality.Initialize" />            
        </OnInitialize>
        <OnShutdown>
            <CallFunction name="Punctuality.Shutdown" />
        </OnShutdown>
        <OnUpdate>
            <CallFunction name="Punctuality.Update" />
        </OnUpdate>
    </UiMod>
    
</ModuleFile>    