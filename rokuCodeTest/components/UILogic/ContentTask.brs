

sub RunContentTask()
    m.contentTask = CreateObject("roSGNode", "MainLoader") ' create task for feed retrieving
    ' observe content so we can know when feed content will be parsed
    m.contentTask.ObserveField("content", "MainContentLoaded")
    m.contentTask.control = "run" ' GetContent(see MainLoader.brs) method is executed
    m.loadingIndicator.visible = true ' show loading indicator while content is loading
    m.GridScreenPage.visible = false
end sub

sub MainContentLoaded() ' invoked when content is ready to be used
    m.GridScreenPage.SetFocus(true) 
    m.GridScreenPage.visible = true
    m.loadingIndicator.visible = false ' hide loading indicator because content was retrieved
    m.GridScreenPage.content = m.contentTask.content 
    args = m.top.launchArgs
    if args <> invalid and CheckDeepLink(args)
        DeepLink(m.contentTask.content, args.mediaType, args.contentId)
    end if
end sub