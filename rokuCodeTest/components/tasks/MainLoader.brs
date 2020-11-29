

' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    ' request the content feed from the API
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://hosttec.online/rokuxml/achei/achei.json")
    rsp = xfer.GetToString()
    rootChildren = []
    rows = {}

    ' parse the feed and build a tree of ContentNodes to populate the GridView
    m.json = ParseJson(rsp)
    if m.json <> invalid
        
        for each category in m.json.categories
                    row = {}
                    row.title = category.name
                    row.children = []
                    
                 videos = GetVideosInCategory(category.playlistName)

                    for each item in videos 
                        itemData = GetItemData(item)
                        row.children.Push(itemData)
                        
                    end for
                    rootChildren.Push(row)
        end for
        ' set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        ' populate content field with root content node.
        ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
        m.top.content = contentNode
    end if
end sub

function GetItemData(video as Object) as Object
    item = {}
    ' populate some standard content metadata fields to be displayed on the GridScreenPage
    
    if video.longDescription <> invalid
        item.description = video.longDescription
    else
        item.description = video.shortDescription
    end if
    item.hdPosterURL = video.thumbnail
    item.title = video.title
    item.releaseDate = video.releaseDate
    item.genre = video.genres[0]
    item.id = video.id
    if video.content <> invalid
        ' populate length of content to be displayed on the GridScreen
        item.length = video.content.duration
        ' populate meta-data for playback
        item.url = video.content.videos[0].url
        item.streamFormat = video.content.videos[0].videoType
        item.quality = video.content.videos[0].quality
    end if
    return item
end function


'function to get all the videos in the category
    function GetVideosInCategory(categoryName as Object) as object
        videos = []
        itemIds=[]
        for each playlistObject in m.json.playlists
            if playlistObject.name = categoryName
                itemIds = playlistObject.itemIds
            end if	
        end for 
        
        for each id in itemIds
            for each tvSpecialObject in m.json.tvSpecials
                if tvSpecialObject.id = id
                    videos.Push(tvSpecialObject)
                end if	
            end for 
            
        end for	
        return videos
    end function	
