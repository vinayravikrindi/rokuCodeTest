

sub ShowDetailsScreenPage(content as Object, selectedItem as Integer)
    detailsScreenPage = CreateObject("roSGNode", "DetailsScreenPage")
    detailsScreenPage.content = content
    detailsScreenPage.jumpToItem = selectedItem ' set index of item which should be focused
    detailsScreenPage.ObserveField("visible", "OnDetailsScreenVisibilityChanged")
    detailsScreenPage.ObserveField("buttonSelected", "ButtonSelected")
    ShowScreen(detailsScreenPage)
end sub

sub OnDetailsScreenVisibilityChanged(event as Object) 
    visible = event.GetData()
    detailsScreen = event.GetRoSGNode()
    currentScreen = GetCurrentScreen()
    screenType = currentScreen.SubType()
    if visible = false
        if screenType = "GridScreenPage"
            ' update GridScreen's focus when navigate back from DetailsScreenPage
            currentScreen.jumpToRowItem = [m.selectedIndex[0], detailsScreen.itemFocused]
        end if
    end if
end sub

sub OnButtonSelected(event) ' invoked when button in DetailsScreenPage is pressed
    details = event.GetRoSGNode()
    content = details.content
    buttonIndex = event.getData() ' index of selected button
    selectedItem = details.itemFocused
    if buttonIndex = 0 ' check if "Play" button is pressed
        ' create Video node and start playback
        ShowVideoScreen(content, selectedItem)
    end if
end sub

