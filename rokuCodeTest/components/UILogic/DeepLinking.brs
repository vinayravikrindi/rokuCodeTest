function GetSupportedMediaTypes() as Object ' returns AA with supported media types
    return {
        "movie": "movies"
        "shortFormVideo": "shortFormVideos"
    }
end function

sub OnInputDeepLinking(event as Object)  ' invoked in case of "roInputEvent"
    args = event.getData()
    if args <> invalid and CheckDeepLink(args) ' validate deep link arguments
        DeepLink(m.GridScreenPage.content, args.mediaType, args.contentId) ' Perform deep linking
    end if
end sub

' check if deep link arguments are valid
function CheckDeepLink(args as Object) as Boolean
   mediaType = args.mediaType
   contentId = args.contentId
   types = GetSupportedMediaTypes()
   return mediaType <> invalid and contentId <> invalid and types[mediaType] <> invalid
end function

' Perform deep linking
sub DeepLink(content as Object, mediaType as String, contentId as String)
    playableItem = FindNodeById(content, contentId) ' find content for deep linking by contentId
    types = GetSupportedMediaTypes()
    ' check if chosen item has appropriate mediaType
    if playableItem <> invalid 
        ClearScreenStack()
        ' looking for appropriate handler for provided mediaType
        if mediaType = "shortFormVideo" or mediaType = "movie"
            PrepareDetailsScreenPage(playableItem)
        end if
    end if
end sub

sub PrepareDetailsScreenPage(content as Object)
    ' create DetailsScreenPage to be shown when user navigate from Video player
    ' it will contain info about played content
    m.deepLinkDetailsScreenPage = CreateObject("roSGNode", "DetailsScreenPage")
    m.deepLinkDetailsScreenPage.content = content
    m.deepLinkDetailsScreenPage.ObserveField("visible", "OnDeepLinkDetailsScreenPageVisibilityChanged")
    m.deepLinkDetailsScreenPage.ObserveField("buttonSelected", "OnDeepLinkDetailsScreenPageButtonSelected")
    AddScreen(m.deepLinkDetailsScreenPage) ' adds DetailsScreen to screen stack but don't show it 
end sub

sub OnDeepLinkDetailsScreenPageVisibilityChanged(event as Object) ' invoked when DetailsScreen "visible" field is changed
    visible = event.GetData()
    screen = event.GetRoSGNode()
    if visible = false and IsScreenInScreenStack(screen) = false
        content = screen.content
        if content <> invalid
            ' jump to appropriate tile on GridScreen
            m.GridScreen.jumpToRowItem = [content.homeRowIndex, content.homeItemIndex]
            ' Invalidate deepLinkDetailsScreen if user press "Back" button on DetailsScreen
            if m.deepLinkDetailsScreenPage <> invalid
                m.deepLinkDetailsScreenPage = invalid
            end if
        end if
    end if
end sub

sub DeeplinkButtonSelected(event as object)
    selectedIndex = event.GetData()
    details = event.GetRoSGNode()
    content = m.deepLinkDetailsScreenPage.content
    if selectedIndex[1] = 0  
        content.bookmarkPosition = 0
        ShowVideoScreen(content, 0) 
    end if
end sub

sub OnDeepLinkDetailsScreenPageButtonSelected(event as Object) 
    buttonIndex = event.getData() 
    details = event.GetRoSGNode()
    content = m.deepLinkDetailsScreenPage.content.clone(true)
    if buttonIndex = 0
        content.bookmarkPosition = 0
        ShowVideoScreen(content, 0) 
    end if
end sub

function FindNodeById(content as Object, contentId as String) as Object
    for each element in content.GetChildren(-1, 0)
        if element.id = contentId
            return element
        else if element.getChildCount() > 0
            result = FindNodeById(element, contentId)
            if result <> invalid
                return result
            end if
        end if
    end for
    return invalid
end function