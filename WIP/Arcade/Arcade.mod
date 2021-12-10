<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

    <UiMod name="warExtended Arcade" version="1.2" date="30/09/21" >
        <Author name="xyeppp" email="" />
        <VersionSettings gameVersion="1.4.8" windowsVersion="1.0.0" savedVariablesVersion="1.2" />
        <Description text="warExtended Arcade module." />

        <Dependencies>
            <Dependency name="warExtended" />
        </Dependencies>

        <Files>
            <File name="Core.lua"  />
            <File name="Draw.lua"  />
            <File name="Weapon.lua"  />
            <File name="Entity.lua"  />
            <File name="Enemy.lua"  />
            <File name="Player.lua"  />
            <File name="Keyboard.lua"  />
            <File name="Window.lua"  />
            <File name="Sound.lua"  />

           <File name="Template.xml" />
           <File name="Window.xml" />
        </Files>

        <OnInitialize>
            <CreateWindow name="warExtendedArcade" show="true"/>
            <CallFunction name="warExtendedSpaceInvaders.OnInitialize"/>
        </OnInitialize>

        <SavedVariables>
        </SavedVariables>

        <Assets>
            <Texture name="warExtendedSpaceInvaderBullet" file="Textures/bullet.tga" />
            <Texture name="warExtendedSpaceInvaderShip" file="Textures/ship.tga" />
            <Texture name="warExtendedSpaceInvaderEnemy" file="Textures/enemy.tga" />
        </Assets>

    </UiMod>
</ModuleFile>
