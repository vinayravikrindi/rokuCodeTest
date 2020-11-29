

sub OnContentSet() ' invoked when item metadata retrieved
    content = m.top.itemContent
    ' set poster uri if content is valid
    if content <> invalid 
        m.top.FindNode("poster").uri = content.hdPosterURL
        m.top.FindNode("bottomTitle").text = content.title
    end if
end sub
