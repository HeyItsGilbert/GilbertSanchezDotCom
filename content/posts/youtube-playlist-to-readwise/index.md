+++
date = 2022-12-30
description = "Build a pipeline from your YouTube Playlist to Readwise!"
summary = "Build a pipeline from your YouTube Playlist to Readwise!"
draft = true
slug = "youtube_playlist_to_readwise"
title = "Syncing your YouTube Playlist to Readise Reader"
+++

## The Situation

I've been using Readwise reader for about a month and I've been enjoying
it. I'm knee deep in the Readwise + Obsidian note band wagon. I'm also a fan of
watching technical videos on the couch. I found myself watching YouTube videos
on my TV and wanting to take notes on them. I create a playlist called 'TVZ'
(based on [Nicole van der Hoven](https://nicolevanderhoeven.com/)'s different
videos on Obsidian and note taking).

## The Problem

The problem I had was that I'd have to remember to go and parse that YouTube
playlist later. Pair that with my ADHD and I was just accumulating a list of
videos that weren't getting processed.

## The Action

I discovered the Readwise Reader API which accepts any address. What I needed to do
was then list my specific playlist )which shouldn't be too tough given that
YouTube has a very robust API) and pass it along.

While I could write a script that maybe runs on a cron, I thought there must be
something easier. I discovered Pipedream which lets you essentially chain several
API's together. It also handles the authentication part for you by prompting
you to login as needed.

{{< alert "lightbulb" >}}
**Note!** You can run tests throughout the workflow setup. This enables you to
make sure you are getting the right data.
{{< /alert >}}

1. Create a Pipedream account
2. Create a new workflow
3. Search for YouTube (Data API) - Not the "Custom App" version.
  {{< figure src="/images/2022/12/youtube_source.png" caption="Searching for YouTube data source" >}}
4. Search for "New Videos in Playlist"
  {{< figure src="/images/2022/12/playlist_trigger.png" caption="New Videos in Playlist option" >}}
5. Login to your YouTube account
6. Set your "Playlist ID" and the name of this source.
7. Click the Plus sign to setup the next step

This is where it gets a little trickier. While Pipedream is aware of Readwise, it
is unaware of the Readwise Reader API. You can still authenticate for Readwise
but you'll need to use some custom code to hit that specific endpoint.

To continue the checklist…

8. Click "Run custom code"
9. Change the code from "nodejs" to "python"
10. Click "Add an App" which will let you add the readwise authentication token
11. Next you can add the following code

```python
import requests

def handler(pd: "pipedream"):
  headers = {"Authorization": f'Token {pd.inputs["readwise"]["$auth"]["accesss_token"]}'}
  vid = pd.steps["trigger"]["event"]["contentDetails"]["videoId"]
  video = "https://youtu.be/" + vid
  r = requests.post('https://readwise.io/api/v3/save/', headers=headers, json={"url": video}  )
  # Export the data for use in future steps
  return r.json()
```

## The Result

Now every 15 minutes (how often I configured my workflow) my playlist is checked
for new videos. This means during my regular Readwise reviews I have a chance to
start creating highlights for my YouTube videos.

## Resources

- Readwise affiliate link: [readwise.io](https://readwise.io/i/gilbert37)
- Readwise Reader API: [readwise.io/reader_api](https://readwise.io/reader_api)
- Pipedream: [pipedream.com](https://pipedream.com)
- Nicole's video on [Taking notes from YouTube videos in Obsidian](https://www.youtube.com/watch?v=qjWq4ck2-0o)