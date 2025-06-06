---
title: "From Terminal to TRMNL: A PowerShell Dashboard Journey"
date: null
description: It’s surprisingly easy to build your own custom dashboard with TRMNL, webhooks, and a bit of PowerShell.
summary: It’s surprisingly easy to build your own custom dashboard with TRMNL, webhooks, and a bit of PowerShell. I used it to send dynamic data (like quotes and images) to an old device—no polling needed, just a simple POST and some fun templating.
showReadingTime: true
draft: false
preview: feature.jpeg
lastmod: 2025-05-04T19:47:47.406Z
slug: terminal-to-trmnl-with-powershell
tags:
  - PowerShell
  - TRMNL
  - REST
keywords:
  - PowerShell
  - TRMNL
  - webhook
series: []
type: posts
fmContentType: posts
---
<!-- spell-checker:ignore TRMNL -->

"I need another monitor" I whisper to myself again… But the "3 monitor curse"
always came to mind. That's a longer story for another time.

I thought about the problem and what I really needed was something to show me
dashboards, remind me of upcoming events, etc. That's when I saw
[Snazzy Labs video about TRMNL](https://www.youtube.com/watch?v=eIcZZX10pa4).
It's funny because I've been trying to figure out how to turn my old kindle into
an e-ink display. Just made sense for low-fidelity stats and low power.

I think the TRMNL business model is really interesting and I love their open
source support. You can build your own device and even use your own server.

Creating your own plugin just takes a few clicks and they support polling for
data or using a webhook. Polling is great if you have one endpoint that has all
the data you're looking for. But what about when you have disparate data? Or
maybe polling the data would be problematic. That's where leveraging the webhook
can come into play.

You know what's good at massaging data and hitting REST endpoints? PowerShell!
This felt like a no-brainer to me.

{{< alert "wand-magic-sparkles" >}}
I was able to get a referral code from TRMNL. If you use `HeyItsGilbert` at the
checkout, you'll get $10 off!
{{< /alert >}}

## Overview

So before we dive into building our own plugin, let's quickly cover a few key
concepts.

<!-- markdownlint-disable-next-line no-inline-html -->
<div style="background-color:white; padding: 20px">
{{< mermaid >}}
sequenceDiagram
    Device-->>Device: Switch Between Views (5m configurable)
    Device->>+TRMNLServer: Update (15m by default)
    TRMNLServer-->>TRMNLServer: Fetch data for polling plugins (different intervals)
    Pwsh->>TRMNLServer: Invoke-RestMethod Post
{{< /mermaid >}}
</div>

You have your physical device which talks to the TRMNL servers (unless you
[brought your own server](https://usetrmnl.com/blog/introducing-byos)). Each of
the screens on the TRMNL device are plugins (or mashups of plugins). Plugins
typically poll (i.e. regularly request) an endpoint for the data they're
showing. They also support creating your own plugins that can work with either
polling, webhooks, or static data.

## Custom Plugins

The TRMNL site allows you to easily create your own plugins. They have a
phenomenal [design system](https://usetrmnl.com/framework) that let's you write
some basic HTML and get back a nice dashboard.

Polling is ideal when:

- The endpoint is available on the web.
- Has easy to use authentication model.
- Has all the data on a single endpoint.

Webhook is ideal when:

- You need to compile/massage the data into the format you want.
- You have multiple endpoints.
- Your auth isn't as straightforward as an HTTP GET.

Static is ideal when:

- Your data doesn't change.

An excellent first step is thinking about what kind of data you want to show,
and how you want it to look. You can start with one of their quickstart examples
and start modifying it to get you your desired look.

## Webhooks & PowerShell

When you create a webhook plugin you are given an address to post your data to.
Sending JSON data is a common thing to do with PowerShell.

```powershell
# Build your hash table to store
$body = @{
  merge_variables = @{
    # All of these items will be available in your plugin
    Quote = $quote
  }
}
$invokeRestMethodSplat = @{
  Method      = 'POST'
  Uri         = 'https://usetrmnl.com/api/custom_plugins/GUID_HERE'
  Body        = $body | ConvertTo-Json -Depth 5
  ContentType = 'application/json'
}
Invoke-RestMethod @invokeRestMethodSplat
```

You'll want to schedule it with your scheduler of choice (e.g., task scheduler,
cron, etc.). You also will want/need to limit how often you send that data. If
you send it too often you'll get a 429 HTTP code.

## Putting it All Together

I need a dashboard that shows me some text and maybe a photo. Of what? Bacon 🥓

Let's start with making the plugin.

1. Create a new [Private Plugin](https://usetrmnl.com/plugin_settings?keyname=private_plugin)
2. Configure your new plugin.
   1. Name your plugin.
      - ![Screenshot of the Name section](image.png)
   2. Set your "Strategy" to "Polling"
      - ![The strategy section](image-1.png)
   3. That's it!
3. Save it and then you'll get a webhook url.
4. You'll then want to copy the "Webhook URL."
   - ![Webhook URL section](image-3.png)

Next we'll write a script so that we can send info to the webhook. Remember to
replace the `GUID_HERE` with your webhook URL GUID.

```powershell
#region Do a bunch of work to get data
$invokeRestMethodSplat = @{
  Method      = 'GET'
  Uri         = "https://baconipsum.com/api/?type=meat-and-filler&paras=5&format=text"
  Body        = $body | ConvertTo-Json -Depth 5
  ContentType = 'application/json'
}
$quote = Invoke-RestMethod @invokeRestMethodSplat
#endregion Do a bunch of work to get data

# Build your hash table to store
$body = @{
  merge_variables = @{
    Picture = "https://baconmockup.com/300/200"
    Quote = $quote
  }
}
$invokeRestMethodSplat = @{
  Method      = 'POST'
  Uri         = 'https://usetrmnl.com/api/custom_plugins/<GUID_HERE>'
  Body        = $body | ConvertTo-Json -Depth 5
  ContentType = 'application/json'
}
Invoke-RestMethod @invokeRestMethodSplat
```

Feel free to run it once so that there is data available when you're building
the markup view.

On the private plugin page you'll want to click on "Edit Markup".
![Edit buttons](image-4.png)

I decided to use one of the examples with a nice large text section.
![Quickstart Example](image-5.png)

The html from that example looks like this:

```html
<div class="layout">
  <div class="columns">
    <div class="column">
      <div class="markdown gap--large">
        <span class="title">First Time Around</span>
        <div class="content-element content clamp--20" data-height-threshold="320">
          <p><i><b>First Time Around</b></i> is a one-disk DVD by Randy Bachman and Burton Cummings recorded in 2006 at CBC Studios in Toronto, Canada, by CBC. It was originally shown on CBC in April 2006, but was later released as a DVD with extended footage of the concert. The concert has 20 tracks of songs by Bachman-Turner Overdrive, Burton Cummings, The Guess Who and cover versions of artists such as Sting and Jimi Hendrix. It was originally shown on CBC in April 2006, but was later released as a DVD with extended footage of the concert. The concert has 20 tracks of songs by Bachman-Turner Overdrive, Burton Cummings, The Guess Who and cover versions of artists such as Sting and Jimi Hendrix Sting and Jimi Hendrix. It was originally shown on CBC in April 2006, but was later released as a DVD with extended footage of the concert. The concert has 20 tracks of songs by Bachman-Turner Overdrive, Burton Cummings, The Guess Who and cover versions of artists such as Sting and Jimi Hendrix Sting and Jimi Hendrix. It was originally shown on CBC in April 2006, but was later released as a DVD with extended footage of the concert. The concert has 20 tracks of songs by Bachman-Turner Overdrive, Burton Cummings, The Guess Who and cover versions of artists such as Sting and Jimi Hendrix.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="title_bar">
  <img class="image" src="https://usetrmnl.com/images/plugins/trmnl--render.svg">
  <span class="title">{{ trmnl.plugin_settings.instance_name }}</span>
  <span class="instance">Description</span>
</div>
```

If you scroll to the bottom, you can see what variables you have. You should see
your data. For my code, I should have a nice bacon quote and address of an
image. ![Your Variables section](image-6.png)

I update the text to use my reference by putting `{{ Quote }}`. I then do a
quick lookup in the design system for showing
[images](https://usetrmnl.com/framework/image). So I add
`<img class="image-dither" src="{{ Picture }}">`. Save that…

```html
<div class="layout">
  <div class="columns">
    <div class="column">
      <div class="markdown gap--large">
        <span class="title">Bacon Zen</span>
        <img class="image-dither" src="{{ Picture }}">
        <div class="content-element content clamp--20" data-height-threshold="320">
          {{ Quote }}
        </div>
      </div>
    </div>
  </div>
</div>

<div class="title_bar">
  <img class="image" src="https://usetrmnl.com/images/plugins/trmnl--render.svg">
  <span class="title">{{ trmnl.plugin_settings.instance_name }}</span>
  <span class="instance">Breathe...</span>
</div>

```

And now!
![Preview screenshot of the plugin](image-7.png)

Make sure to add it to your playlist!

![Photo of the plugin showing on a TRMNL device](photo.jpg)
And now you can find your zen…

## But Seriously

This is obviously a silly example, but it shows you how easy it is to build a custom plugin and easily send data with PowerShell.

What's a more realistic example? How about pending GitHub PR's from work
repository? That's not type of data you or your security team may want the TRMNL
servers polling. But a local PowerShell script running as you plus the ability
to send a limited subset of information, that's probably less of a concern.

Or maybe you're taking data from across multiple sources and calculating some
metrics. Or maybe many metrics. What about pending PR's AND stats about a Jira
queues? Anything is possible!

## Tips

The docs are pretty good and if you're stuck make sure to check them out.

1. Arrays are an excellent way to track lists, but hash tables work even better!
   - [Handling Lists](https://help.usetrmnl.com/en/articles/10671186-liquid-101#h_36fa49cde9)
   - Think of handling a single item as an object - something PowerShell is great at!
2. Limit how often you send your data to avoid 429 HTTP codes. I shoot for every 15 or 30 minutes.
3. The "Liquid" templating language has a lot of useful functions and filters.
   - Check out the
    [Advanced doc](https://help.usetrmnl.com/en/articles/10693981-advanced-liquid)
