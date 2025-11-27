---
date: 2022-12-31T02:00:00.000Z
description: Build a pipeline from your YouTube Playlist to Readwise!
summary: Build a pipeline from your YouTube Playlist to Readwise!
draft: false
slug: youtube_playlist_to_readwise
title: Syncing your YouTube Playlist to Readwise Reader
lastmod: 2025-11-27T17:00:29.559Z
keywords:
  - python
  - readwise
tags:
  - Python
  - Readwise
  - Obsidian
preview: feature.webp
---

## The Situation

I've been using Readwise reader for about a month and I've been enjoying it.
Plus I'm knee-deep in the Readwise + Obsidian note bandwagon. I'm also a fan of
watching technical videos on the couch. I found myself watching YouTube videos
on my TV and wanting to take notes on them. I created a playlist called 'TVZ'
(based on [Nicole van der Hoven](https://nicolevanderhoeven.com/)'s different
videos on Obsidian and note-taking).

## The Problem

The problem I had was that I'd have to remember to go and parse that YouTube
playlist later. Pair that with my ADHD, and I was just accumulating a list of
videos that weren't getting processed.

## The Action

I discovered the Readwise Reader API which enables you to save any URL. That
plus them going public and offering a YouTube solution meant I could start
saving and highlighting videos. What I needed to do was list out my specific
playlist (not difficult with the YouTube API) and pass the video addresses along
to the Readwise API.

While I could write a script that maybe runs on a cron, I thought there must be
something easier. I discovered Pipedream which lets you essentially chain several
APIs together. It also handles the authentication part for you by prompting
you to login as needed.

### Prerequisites

To start you'll want to set up the following:

1. Create a YouTube playlist that you want to sync.
2. Sign up for a [Pipedream](https://pipedream.com) account.
3. Connect your YouTube and Readwise accounts.
   - Learn more at
     [Pipedream Connected Accounts](https://pipedream.com/docs/connected-accounts/#connecting-a-new-account)

### Creating the Workflow

{{< alert "lightbulb" >}}
**Note!** You can run tests throughout the workflow setup. This enables you to
make sure you are getting the right data.
{{< /alert >}}

1. Create a new workflow
2. Search for YouTube (Data API) - Not the "Custom App" version.
   {{< figure src="/images/2022/12/youtube_source.webp" caption="Searching for YouTube data source" >}}
3. Search for "New Videos in Playlist"
   {{< figure src="/images/2022/12/playlist_trigger.webp" caption="New Videos in Playlist option" >}}
4. Login to your YouTube account (see Prerequisites above)
5. Set your "Playlist ID" and the name of this source.
6. Click the Plus sign to set up the next step
    - This is where it gets a little trickier. While Pipedream is aware of
      Readwise, it's unaware of the Readwise **Reader** API. You can still
      authenticate for Readwise, but you'll need to use some custom code to hit
      that specific endpoint.
7. Click "Run custom code"
8. Change the code from "nodejs" to "python"
9. Click "Add an App" which will let you add the Readwise authentication token
10. Next you can add the following code

```python
import requests

def handler(pd: "pipedream"):
  headers = {"Authorization": f'Token {pd.inputs["readwise"]["$auth"]["access_token"]}'}
  vid = pd.steps["trigger"]["event"]["contentDetails"]["videoId"]
  video = "https://youtu.be/" + vid
  r = requests.post('https://readwise.io/api/v3/save/', headers=headers, json={"url": video}  )
  # Export the data for use in future steps
  return r.json()
```

Save your workstream and feel free to test it through.

## The Result

Now every 15 minutes (how often I configured my workflow) the workflow scans my
playlist for new videos. This means during my regular Readwise reviews I have a
chance to start creating highlights for my YouTube videos.

{{< alert "circle-info" >}}
Updated to make adding the two accounts more obvious.
{{< /alert >}}

## Resources

- Readwise affiliate link: [readwise.io](https://readwise.io/i/gilbert37)
- Readwise Reader API: [readwise.io/reader_api](https://readwise.io/reader_api)
- Pipedream: [pipedream.com](https://pipedream.com)
- Nicole's video on
  [Taking notes from YouTube videos in Obsidian](https://www.youtube.com/watch?v=qjWq4ck2-0o)
