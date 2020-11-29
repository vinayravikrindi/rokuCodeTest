
' entry point of GridScreenPage
' Note that we need to import this file in GridScreenPage.xml using relative path.
sub Init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    ' label with item description
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    ' observe visible field so we can GridScreenPage change visibility
    m.top.ObserveField("visible", "OnVisibleChange")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.thumbnail = m.top.FindNode("thumbnailPoster")
    m.releaseDate = m.top.FindNode("releaseDate")
    m.videoQuality = m.top.FindNode("quality")
    m.genre = m.top.FindNode("genre")
    
    ' observe rowItemFocused so we can know when another item of rowList will be focused
    m.rowList.ObserveField("rowItemFocused", "OnItemFocused")
end sub

sub OnVisibleChange() ' invoked when GridScreenPage change visibility
    if m.top.visible = true
        m.rowList.SetFocus(true) ' set focus to rowList if GridScreenPage visible
    end if
end sub

sub OnItemFocused() ' invoked when another item is focused
    focusedIndex = m.rowList.rowItemFocused ' get position of focused item
    row = m.rowList.content.GetChild(focusedIndex[0]) ' get all items of row
    item = row.GetChild(focusedIndex[1]) ' get focused item
    m.descriptionLabel.text = item.description
    m.titleLabel.text = item.title
    m.releaseDate.text = left(item.releaseDate, 10)
    m.thumbnail.uri = item.hdPosterURL
    m.genre.text = item.genre
    m.videoQuality.text = item.quality   
end sub

