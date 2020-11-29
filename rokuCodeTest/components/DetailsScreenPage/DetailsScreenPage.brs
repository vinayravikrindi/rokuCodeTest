
function Init()
    m.top.ObserveField("visible", "OnVisibleChange")
    ' observe "itemFocused" so we can know when another item gets in focus
    m.top.ObserveField("itemFocused", "ItemFocusedChanged")
    m.buttons = m.top.FindNode("buttons")
    m.description = m.top.FindNode("descriptionLabel")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.thumbnail = m.top.FindNode("thumbnailPoster")
end function

sub onVisibleChange()
    if m.top.visible = true
        m.buttons.SetFocus(true)
    end if
end sub

sub SetButtons(buttons as Object)
    result = []
    for each button in buttons 
        result.push({title : button})
    end for
    m.buttons.content = ContentListToSimpleNode(result) 
end sub

sub OnContentChange(event as Object)
    content = event.getData()
    if content <> invalid
        m.isContentList = content.GetChildCount() > 0
        if m.isContentList = false
            DetailsScreenPageContent(content)
            m.buttons.SetFocus(true)
        end if
    end if
end sub

sub DetailsScreenPageContent(content as Object)
    ' populate screen components with metadata
    m.description.text = content.description
    m.titleLabel.text = content.title
    m.thumbnail.uri = content.hdPosterURL
    SetButtons(["Watch Now", "Add to watchlist"])
end sub

sub OnJumpToItem() ' invoked when jumpToItem field is populated
    content = m.top.content
    ' check if jumpToItem field has valid value
    ' it should be set within interval from 0 to content.Getchildcount()
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub

sub ItemFocusedChanged(event as Object)' invoked when another item is focused
    focusedItem = event.GetData() ' get position of focused item
    if m.top.content.GetChildCount() > 0
        content = m.top.content.GetChild(focusedItem) ' get metadata of focused item
        DetailsScreenPageContent(content) 
    end if 
end sub

' The KeyEvent() function receives remote control key events
function keyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        currentItem = m.top.itemFocused ' position of currently focused item
        ' handle "left" button keypress
        if key = "left" and m.isContentList = true
            ' navigate to the left item in case of "left" keypress
            m.top.jumpToItem = currentItem - 1
            result = true
        ' handle "right" button keypress
        else if key = "right" and m.isContentList = true
            ' navigate to the right item in case of "right" keypress
            m.top.jumpToItem = currentItem + 1
            result = true
        end if
    end if
    return result
end function


' Helper function convert AA to Node
function ContentListToSimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
    result = CreateObject("roSGNode", nodeType) ' create node instance based on specified nodeType
    if result <> invalid
        ' go through contentList and create node instance for each item of list
        for each itemAA in contentList
            item = CreateObject("roSGNode", nodeType)
            item.SetFields(itemAA)
            result.AppendChild(item) 
        end for
    end if
    return result
end function
