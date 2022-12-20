if not Mesh then Mesh = {} end
local Mesh = Mesh
local WindowSetDimensions, WindowSetShowing, CreateWindow, CreateWindowFromTemplate, WindowAddAnchor, WindowSetTintColor,
	  WindowClearAnchors, ceil, tonumber, floor, DoesWindowExist, WindowGetShowing, DestroyWindow =
	  WindowSetDimensions, WindowSetShowing, CreateWindow, CreateWindowFromTemplate, WindowAddAnchor, WindowSetTintColor,
	  WindowClearAnchors, math.ceil, tonumber, math.floor, DoesWindowExist, WindowGetShowing, DestroyWindow
local MeshVertLine, MeshHoriLine, MeshTemp, windowName = "MeshVerticalLine", "MeshHorizontalLine", "MeshLineTemplate", "Mesh"
local meshSizeDefault = 16
Mesh.isMeshing = false
Mesh.meshSizeCurrent = meshSizeDefault


function Mesh.CreateMesh(meshSize)
	Mesh.DestroyMesh()
	CreateWindow(windowName, true)
	WindowSetDimensions(windowName, WindowGetDimensions("Root"))
	WindowSetShowing(windowName, true)

	if meshSize == nil then
		meshSize = Mesh.meshSizeCurrent
	elseif meshSize > 256 then
		meshSize = 256
	end

	meshSize = ceil(meshSize / 16) * 16
	Mesh.meshSizeCurrent = meshSize

	local w, h = WindowGetDimensions("Root")
	local ratio = w / h
	local wSpacing = w / meshSize
	local hSpacing = (h / meshSize) * ratio
	local scale = InterfaceCore.GetScale()
	local line = 1 / scale

	for lineNumber = 1, meshSize do
		CreateWindowFromTemplate(MeshVertLine..lineNumber, MeshTemp, windowName)
		WindowSetDimensions(MeshVertLine..lineNumber, line, h)
		WindowAddAnchor(MeshVertLine..lineNumber, "left", windowName, "right", (lineNumber * wSpacing) + line, 0)
		WindowSetShowing(MeshVertLine..lineNumber, true)
	end

	for lineNumber = 1, floor(h / hSpacing) do
		CreateWindowFromTemplate(MeshHoriLine..lineNumber, MeshTemp, windowName)
		WindowSetDimensions(MeshHoriLine..lineNumber, w, line)
		WindowAddAnchor(MeshHoriLine..lineNumber, "top", windowName, "bottom", 0, (lineNumber * hSpacing) + line)
		WindowSetShowing(MeshHoriLine..lineNumber, true)
	end

	CreateWindowFromTemplate("MeshVerticalCenterLine", MeshTemp, windowName)
	WindowSetDimensions("MeshVerticalCenterLine", line, h)
	WindowAddAnchor("MeshVerticalCenterLine", "center", windowName, "center", 0, 0)
	WindowSetTintColor("MeshVerticalCenterLine", 255, 1, 1)
	WindowSetShowing("MeshVerticalCenterLine", true)

	CreateWindowFromTemplate("MeshHorizontalCenterLine", MeshTemp, windowName)
	WindowSetDimensions("MeshHorizontalCenterLine", w, line)
	WindowAddAnchor("MeshHorizontalCenterLine", "center", windowName, "center", 0, 0)
	WindowSetTintColor("MeshHorizontalCenterLine", 255, 1, 1)
	WindowSetShowing("MeshHorizontalCenterLine", true)

	Mesh.isMeshing = true
end

function Mesh.DestroyMesh()
	if DoesWindowExist(windowName) and WindowGetShowing(windowName) then
		DestroyWindow(windowName)
	end

	Mesh.isMeshing = false
end

function Mesh.Show()
	Mesh.CreateMesh(Mesh.meshSizeCurrent)
end

function Mesh.Hide()
	Mesh.DestroyMesh()
	Mesh.meshSizeCurrent=nil
end

function Mesh.Toggle(meshSize)
	if meshSize==nil then
		if DoesWindowExist(windowName) and WindowGetShowing(windowName) then
			 Mesh.Hide()
			 	pp("Hiding on-screen grid.")
		 else
			 pp("Usage: mesh(meshSize) - min 16-256 max")
		 end
	else
	if meshSize == Mesh.meshSizeCurrent then
		if DoesWindowExist(windowName) and WindowGetShowing(windowName) then
			 Mesh.Hide()
			 	pp("Hiding on-screen grid.")
		 end
	elseif meshSize ~= Mesh.meshSizeCurrent then
		Mesh.CreateMesh(meshSize)
		pp("Showing on-screen grid.")
	end
end
end

function Mesh.MeshCheck()
	if Mesh.isMeshing == true then Mesh.Show() end
end
