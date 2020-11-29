
sub ShowGridScreenPage()
    m.GridScreenPage = CreateObject("roSGNode", "GridScreenPage")
    m.GridScreenPage.ObserveField("rowItemSelected", "GridScreenPageItemSelected")
    ShowScreen(m.GridScreenPage) ' show GridScreenPage
end sub

sub GridScreenPageItemSelected(event as Object) ' invoked when GridScreenPage item is selected
    grid = event.GetRoSGNode()
    ' extract the row and column indexes of the item the user selected
    m.selectedIndex = event.GetData()
    ' the entire row from the RowList will be used by the Video node
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    ShowDetailsScreenPage(rowContent, m.selectedIndex[1])
end sub