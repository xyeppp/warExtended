warExtendedSurrender = warExtended.Register("warExtended Surrender Vote")

local Surrender = warExtendedSurrender
local WINDOW_NAME = "warExtendedSurrenderVote"
local WINDOW = Frame:Subclass(WINDOW_NAME)
local LAYOUT_DESCRIPTION = L"Surrender Vote Window"
local TITLEBAR_TEXT = L"Surrender Vote"
local CHAT_LOG = TextLog:Subclass("Chat")

local SURRENDER_START_STRING = L"([%a]+) started surrender vote!"
local SURRENDER_VOTE_STRING = L"([%a]+) voted ([%a]+) for surrender."
local SURRENDER_END_STRING = L"Surrender vote for"

local VOTE_COLORS = {
    [L"Yes"] = {r=50,g=200,b=50};
    [L"No"] = {r=200,g=50,b=50};
}

local TITLEBAR = 1
local VOTE_YES = 2
local VOTE_NO = 3
local VOTE_BACKGROUND = 4
local VOTE_CLASS = 5
local VOTE_BORDER = 6
local STATUS_BAR = 7
local CORNER_IMG = 10

local VOTE_TIMER = 140
local CORNER_IMG_SIZE = 116

local BORDER_PADDING_X = 2.5
local VOTE_PADDING_Y = 11
local VOTE_OFFSET_X = 2

local FRAME_X = 393
local FRAME_Y_EXTENDED =  160
local FRAME_Y = 118

local VOTE_FRAME = Frame:Subclass(WINDOW_NAME.."Template")

function VOTE_FRAME:Vote(playerName, voteChoice)
    local surrenderFrame = self:GetParent()
    if not surrenderFrame:IsVoteInProgress() then
        return
    end

    local win = self.m_Windows
    local playerIdx = surrenderFrame.m_scenarioPlayers[playerName].idx
    voteChoice = Surrender:Capitalize(voteChoice)

    self.m_playerName = playerName
    self.m_playerRank = Surrender:toWString(playerData[playerIdx].rank)
    self.m_playerClass = playerData[playerIdx].career

    local texture,_ ,_ = GetIconData(Surrender:GetCareerIcon(self.m_playerClass))
    win[VOTE_BACKGROUND]:SetTint(VOTE_COLORS[voteChoice])
    win[VOTE_BACKGROUND]:SetTexture(texture)
    win[VOTE_CLASS]:SetTexture(texture, 16, 16)
    self:Show(true)
end

function VOTE_FRAME:OnMouseOver()
    local anchor = { Point = "top", RelativeTo = self:GetName(), RelativePoint = "top", XOffset = 0, YOffset = -90 }

    Surrender:CreateTextTooltip(self:GetName(), {
        [1]={
            [1] = {text = L"Name: ", color=Tooltips.COLOR_HEADING},
            [3] = {text = self.m_playerName}
        },
        [2]={
            [1] = {text = L"Career: ", color=Tooltips.COLOR_HEADING},
            [3] = {text = self.m_playerClass}
        },
        [3]={
            [1] = {text = L"Rank: ", color=Tooltips.COLOR_HEADING},
            [3] = {text = self.m_playerRank}
        }
    }, nil, anchor, nil)

end

function WINDOW:StartVoteTimer()
    local frame = self
    local win = self.m_Windows
    win[STATUS_BAR]:SetMaximumValue(VOTE_TIMER)
    win[STATUS_BAR]:SetCurrentValue(VOTE_TIMER)
    win[STATUS_BAR]:StopInterpolating()
    win[STATUS_BAR]:SetText(TimeUtils.FormatClock(VOTE_TIMER))

    warExtendedTimer.New (WINDOW_NAME, 1,
            function (self)
                win[STATUS_BAR]:SetText(TimeUtils.FormatClock(VOTE_TIMER - self.timeout))
                win[STATUS_BAR]:SetCurrentValue(VOTE_TIMER - self.timeout)

                if self.timeout > VOTE_TIMER then
                    if not frame:HasPlayerVoted() then
                        Surrender:Send(L"]No")
                    end
                    return true
                else
                    return false
                end
            end)
end

function WINDOW:GetScenarioPlayerCount()
    self.m_scenarioPlayerCount = 0
    self.m_scenarioPlayers = {}

    if GameData.Player.isInScenario then
        local groupData = GameData.GetScenarioPlayerGroups()

        for playerCount = 1,#groupData do
            local player = groupData[playerCount]
            if player.name ~= L"" then
                self.m_scenarioPlayerCount = self.m_scenarioPlayerCount + 1
                self.m_scenarioPlayers[player.name] = {
                    hasVoted = false,
                    idx = playerCount
                }
            end
        end
    end

end

function WINDOW:IsVoteInProgress()
    return self.m_isVoteInProgress
end

function WINDOW:AddVote(playerName, voteChoice)
    if not self:IsVoteInProgress() or self.m_scenarioPlayers[playerName].hasVoted then
        return
    end

    self.m_scenarioPlayers[playerName].hasVoted = true
    self.m_totalVotes = self.m_totalVotes + 1

    if self:HasPlayerVoted() then
        self:UpdateDisplay()
    end

    local voteFrame = GetFrame(WINDOW_NAME.."Player"..self.m_totalVotes)
    voteFrame:Vote(playerName, voteChoice)
end

function WINDOW:CreateVoteFrames()
    local borderWindow = self.m_Windows[VOTE_BORDER]
    local borderX, borderY = borderWindow:GetDimensions()

    local width, height = ( borderX / self.m_scenarioPlayerCount ) - BORDER_PADDING_X , (borderY - VOTE_PADDING_Y)

    for playerNumber = 1, self.m_scenarioPlayerCount do
        local frame = VOTE_FRAME:CreateFromTemplate(WINDOW_NAME.."Player"..playerNumber, WINDOW_NAME.."VoteBorder")
        if frame then
            frame:SetDimensions(width, height)
            frame:SetParent(WINDOW_NAME)

            frame.m_Windows = {
                [VOTE_BACKGROUND] = DynamicImage:CreateFrameForExistingWindow(frame:GetName().."Background"),
                [VOTE_CLASS] = CircleImage:CreateFrameForExistingWindow(frame:GetName().."CareerIcon")
            }

            if playerNumber > 1 then
                frame:SetAnchor({Point = "right", RelativePoint = "left", RelativeTo = WINDOW_NAME.."Player"..playerNumber-1, XOffset = VOTE_OFFSET_X,})
            end

        end

    end
end

function WINDOW:StartSurrenderVote(text)
    if not self:IsVoteInProgress() then
        self:GetScenarioPlayerCount()

        local playerName = text:match(SURRENDER_START_STRING)
        if self.m_scenarioPlayers[playerName] == nil then
            return
        end
    end

    if self:IsVoteInProgress() then
        return
    else
        self.m_isVoteInProgress = not self:IsVoteInProgress()
    end

    self.m_totalVotes = 0

    self:CreateVoteFrames()
    self:StartVoteTimer()
    self:UpdateDisplay()
end

function WINDOW:HasPlayerVoted()
    if not self:IsVoteInProgress() then
        return false
        else
        return self.m_scenarioPlayers[Surrender:GetPlayerName()].hasVoted
    end
end

function WINDOW:StopSurrenderVote()
    if not self:IsVoteInProgress() then
        return
    end

    self.m_isVoteInProgress = false

    for player=1,self.m_scenarioPlayerCount do
        local frame = GetFrame(WINDOW_NAME.."Player"..player)
        local win = frame.m_Windows
        win[VOTE_BACKGROUND]:Destroy()
        win[VOTE_CLASS]:Destroy()
        frame:Destroy()
    end

    self.m_totalVotes = 0;
    self.m_scenarioPlayers = nil;
end

function WINDOW:UpdateDisplay()
    local isVoteInProgress = self:IsVoteInProgress()
    local hasPlayerVoted = self:HasPlayerVoted()
    local win = self.m_Windows

    self:Show(isVoteInProgress)

    if isVoteInProgress then
        win[VOTE_YES]:Show(not hasPlayerVoted)
        win[VOTE_NO]:Show(not hasPlayerVoted)
        if hasPlayerVoted then
            self:SetDimensions(FRAME_X, FRAME_Y, Frame.FORCE_OVERRIDE)
        else
            self:SetDimensions(FRAME_X, FRAME_Y_EXTENDED)
        end
    end
end

function WINDOW:ProcessSurrenderText(surrenderText)
    if surrenderText:find(SURRENDER_START_STRING) and not self:IsVoteInProgress() then
        self:StartSurrenderVote(surrenderText)
        return
        elseif surrenderText:find(SURRENDER_END_STRING) and self:IsVoteInProgress() then
        self:StopSurrenderVote()
        return
    end

    local playerName, voteChoice = surrenderText:match(SURRENDER_VOTE_STRING)
    if playerName and voteChoice then
        self:AddVote(playerName, voteChoice)
    end
end

function Surrender.ClearSurrenderVote()
    local frame = GetFrame(WINDOW_NAME)
    frame:StopSurrenderVote()
end

function Surrender.OnChatUpdate(updateType, filterType)
    if not GameData.Player.isInScenario then
        return
    end

    if( updateType == SystemData.TextLogUpdate.ADDED ) then
        local _,_,text = CHAT_LOG:GetLastEntry()
        local surrenderText = (text:find(SURRENDER_VOTE_STRING) or text:find(SURRENDER_START_STRING) or text:find(SURRENDER_END_STRING))
        if surrenderText then
            local frame = GetFrame(WINDOW_NAME)
            frame:ProcessSurrenderText(text)
        end
    end
end

function Surrender.OnInitialize()
    local frame = WINDOW:CreateFrameForExistingWindow(WINDOW_NAME)
    if frame then
        local VOTE_BUTTON = ButtonFrame:Subclass()

        VOTE_BUTTON.OnLButtonUp = function(self, ...)
            local voteChoice = self:GetName():match(WINDOW_NAME.."(.*)")
            p(voteChoice)
            if not frame:HasPlayerVoted() then
                Surrender:Send("]"..voteChoice)
            end
        end

        frame.m_Windows = {
            [TITLEBAR] = Label:CreateFrameForExistingWindow(frame:GetName() .. "TitleBarLabel"),
            [CORNER_IMG] = DynamicImage:CreateFrameForExistingWindow(frame:GetName() .. "CornerImage"),
            [VOTE_YES] = VOTE_BUTTON:CreateFrameForExistingWindow(frame:GetName().."Yes"),
            [VOTE_NO] = VOTE_BUTTON:CreateFrameForExistingWindow(frame:GetName().."No"),
            [VOTE_BORDER] = FullResizeImage:CreateFrameForExistingWindow(frame:GetName().."VoteBorder"),
            [STATUS_BAR] = warExtendedDefaultStatusBar:Create(frame:GetName().."Timer")
        }

        frame.m_isVoteInProgress = false;
        frame.m_scenarioPlayers = {}

        frame:SetScript(CHAT_LOG:GetUpdateEventId(), "warExtendedSurrender.OnChatUpdate")
        frame:SetScripts({ "scenario end", "scenario begin" }, "warExtendedSurrender.ClearSurrender")

        frame:RegisterLayoutEditor(LAYOUT_DESCRIPTION, LAYOUT_DESCRIPTION, true, true, true, nil)
        frame:RegisterLayoutEditorCallback(function (editorCode)
            if (editorCode == LayoutEditor.EDITING_END) then
                frame:Show(frame:IsVoteInProgress(), Frame.FORCE_OVERRIDE)
            end
        end)

        local win = frame.m_Windows

        win[TITLEBAR]:SetText(TITLEBAR_TEXT)
        win[CORNER_IMG]:SetTextureDimensions(CORNER_IMG_SIZE, CORNER_IMG_SIZE)
        win[VOTE_YES]:SetText(GetString(StringTables.Default.LABEL_YES))
        win[VOTE_NO]:SetText(GetString(StringTables.Default.LABEL_NO))

        frame:UpdateDisplay()
    end
end