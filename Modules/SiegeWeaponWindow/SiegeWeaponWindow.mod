<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Siege Weapon Window" version="1.1" date="07/01/2024" >
        <Replaces name="EA_SiegeWeaponWindow" />
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" />
        <Description text="This module contains all of the windows for building and firing siege weapons. Fixes the siege chat filters to be in-line with your chat filters." />
        <Dependencies>                
            <Dependency name="warExtended" />
            <Dependency name="EATemplate_DefaultWindowSkin" />
            <Dependency name="EASystem_Utils" />
            <Dependency name="EASystem_WindowUtils" />
            <Dependency name="EASystem_Tooltips" />
            <Dependency name="EA_ChatWindow" />
        </Dependencies>
        <Files>        
            <File name="Original/Textures/SiegeTextures.xml" />
            <File name="Original/Source/SiegeWeaponBuildWindow.xml" />
            <File name="Original/Source/SiegeWeaponControlWindow.xml" />
            <File name="Original/Source/SiegeWeaponGeneralFireWindow.xml" />
            <File name="Original/Source/SiegeWeaponSniperFireWindow.xml" />
            <File name="Original/Source/SiegeWeaponScorchFireWindow.xml" />
            <File name="Original/Source/SiegeWeaponGolfFireWindow.xml" />
            <File name="Original/Source/SiegeWeaponSweetSpotFireWindow.xml" />

            <File name="Core.lua" />
        </Files>
        <OnInitialize>
            <CreateWindow name="SiegeWeaponBuildWindow" show="false" />
            <CreateWindow name="SiegeWeaponInfoWindow" show="false" />    
            <CreateWindow name="SiegeWeaponStatusWindow" show="false" />                    
            <CreateWindow name="SiegeWeaponUsersWindow" show="false" />          
            <CreateWindow name="SiegeWeaponControlWindow" show="false" />
            <CreateWindow name="SiegeWeaponGeneralFireWindow" show="false" />
            <CreateWindow name="SiegeWeaponSniperFireWindow" show="false" />
            <CreateWindow name="SiegeWeaponScorchFireWindow" show="false" />
            <CreateWindow name="SiegeWeaponGolfFireWindow" show="false" />
            <CreateWindow name="SiegeWeaponSweetSpotFireWindow" show="false" />
        </OnInitialize>             
    </UiMod>
    
</ModuleFile>    