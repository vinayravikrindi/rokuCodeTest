

sub ShowVideoScreen(rowContent as Object, selectedItem as Integer)
    m.videoPlayer = CreateObject("roSGNode", "Video") 
    if selectedItem <> 0 
        numOfChildren = rowContent.GetChildCount() 
        children = rowContent.GetChildren(numOfChildren - selectedItem, selectedItem)
        childrenClone = []
        for each child in children
            childrenClone.Push(child.Clone(false))
        end for
        rowNode = CreateObject("roSGNode", "ContentNode")
        rowNode.Update({ children: childrenClone }, true)
        m.videoPlayer.content = rowNode 
    else
        m.videoPlayer.content = rowContent.Clone(true)
    end if
    m.videoPlayer.contentIsPlaylist = true 
    ShowScreen(m.videoPlayer) 
    m.videoPlayer.control = "play" 
    m.videoPlayer.ObserveField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.ObserveField("visible", "OnVideoVisibleChange")
end sub

sub OnVideoPlayerStateChange() ' invoked when video state is changed
    state = m.videoPlayer.state
    ' close video screen in case of error or end of playback
    if state = "error" or state = "finished"
        CloseScreen(m.videoPlayer)
    end if
end sub

sub OnVideoVisibleChange() ' invoked when video node visibility is changed
    if m.videoPlayer.visible = false and m.top.visible = true
        ' the index of the video in the video playlist that is currently playing.
        currentIndex = m.videoPlayer.contentIndex
        m.videoPlayer.control = "stop" ' stop playback
        'clear video player content, for proper start of next video player
        m.videoPlayer.content = invalid
        m.GridScene.SetFocus(true)  
        screen = event.GetRoSGNode()
        content = screen.content
        if content <> invalid
            m.GridScreenPage.jumpToRowItem = [content.homeRowIndex, currentIndex + content.homeItemIndex]
        end if
    end if
end sub