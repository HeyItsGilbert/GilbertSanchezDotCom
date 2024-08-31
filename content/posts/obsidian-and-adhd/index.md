---
title: Taming My ADHD with Obsidian and PowerShell
date: 2024-08-31T01:15:28.508Z
description: Alleviating my ADHD headaches with Obsidian. Periodic Notes and Templater extensions save the day by reminding me of the next step towards my larger goals.
summary: Alleviating my ADHD headaches with Obsidian. Periodic Notes and Templater extensions save the day by reminding me of the next step towards my larger goals.
showReadingTime: true
draft: false
preview: feature.png
cover: feature.png
tags:
  - PowerShell
  - PKM
keywords: []
series: []
type: posts
fmContentType: posts
lastmod: 2024-08-31T01:31:37.291Z
slug: obsidian-and-adhd
featureAlt: Public Domain art showing planets.
coverCaption: We 💞 [Public Domain Art](https://www.cosmos.so/e/627080146)
---

> This is a modified version of a post I wrote at work last year. I recently
> mentioned to someone that you can run PowerShell from Obsidian, and I realized
> this might be helpful to share publicly.

If you're new to Obsidian, it can be feel *very* overwhelming. There are dials
and knobs for everything. **Start slow** and only add things when you need them.
Realize it's an iterative process. This can help calm the fears of never
hitting perfection. Keep what works, ditch what doesn't.

{{< lead >}}
Ship and Iterate
{{< /lead >}}

<!-- FM:Snippet:Start data:{"id":"Call Out","fields":[]} -->
{{< alert >}}
**Warning!** A lot of this was stuff I've picked up from folks in the community. I
never kept track for attribution so it's safe to assume it was written by
someone smarter than me. If you know, please let me know!
{{< /alert >}}
<!-- FM:Snippet:End -->

## ADHD and Obsidian

As a neurodivergent person (or as the kids now say "spicy brain") I am always on
the look out for ways I can improve my process. Identifying my weaknesses has
helped me focus on specific areas for improvement. I'll briefly go over the
problems I was having, and what aspects helped (so you can steal what is helpful
for you).

### Object Permanence

I definitely deal with object permanence issues (aka "out of sight out of mind")
which means that I need to keep things in front of me. To do that, I leverage a
[daily note](#daily-note) that shows me: weekly goals, daily schedule, incomplete
note/posts/etc., and unfinished tasks. I also have a log section for me to keep
track of stuff I'm working on.

### Task Initiation

When I'm given a giant task, it can feel daunting to know where to start. By
using the [periodic note system](#periodic-notes), I'm able to start at a very
high level and then break things down into smaller bits. Breaking tasks into
smaller parts makes it easier to get started.

### Forgetfulness

I can often remember the general idea of something but not the details. So I may
not recall the name "Lamport Clock", but I do recall that it's related to
Distributed Systems. By creating "Atomic" notes and tagging related things it
allows me to be able to walk the node of related notes because I know they're
likely linking to each other.

## My Folder Structure

I think this is the thing most folks get hung up on. Folders help with
organization, but linking is what makes Obsidian powerful. I started with only
the first 3 and then added more as I saw the need.

- `0000 Atomics`: "Evergreen" notes that should be about one thing. I'm pretty
  loose with this and I'm ok with that.
- `1000 Daily Notes`: All my daily, weekly, and monthly notes live here.
- `2000 Status Reports`: All my status reports live here. The file names
  conflicted with Daily Notes so it got its own folder.
- `3000 Meeting Notes`: A folder for all my meeting notes.
- `4000 Posts`:  WP posts.
- `5000 People`: Notes about people.
- `Files`: All embedded files (e.g., images and PDFs)
- `Templates`: All the templates and scripts.

I've found that less folders is better and even the above can feel like a lot.
Use what feels right, and toss what doesn't!

## My Templates

All of these notes use the
[Templater](obsidian://show-plugin?id=templater-obsidian) plugin.
It's the one plugin I explain is a must with Obsidian.

### Periodic Notes

I borrowed this idea mostly from Nicole van der Hoven (aka NVDH) (see her video
[How to set goals in Obsidian // Templates, Periodic Notes](https://www.youtube.com/watch?v=T2Aeaq4sk7M)).
The idea is that I have yearly goals, but unless that's broken down I'm not
likely to take much action (see [task initiation](#task-initiation)). The daily
note template is complex enough to deserve its own section.

I create a yearly note with all my goals. I put together a rough outline for the
year which helps me fill out my monthly notes. The monthly template shows the
yearly goals by embedding them at the top. This helps with keeping monthly goals
aligned to yearly ones. The weekly note embeds the monthly goals, and finally
the daily note shows the weekly goals. The idea here is that each step down
toward a daily view becomes more specific.

The [Obsidian Periodic Notes](obsidian://show-plugin?id=periodic-notes) plugin
makes this really easy and is on my short list of recommended plugins.

- [Yearly OKRs.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-yearly-okrs)
- [Weekly Review.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-weekly-review)
- [Monthly Review.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-monthly-review)

### Daily Note

The "Daily Note" template is at the core of this. This does most of the leg work
of figuring out days and creating relevant links. The Daily Note template uses
the Dataview plugin as well as the Tasks plugin to gather data across my notes.

Since my schedule differs on Wednesdays and Fridays, I use a simple switch (in
the 'DailyFolderSwitch' template) to load the correct template. Each schedule
template then runs a different PowerShell command to get my schedule (see the
PowerShell script below).

- [Daily Note.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-daily-note)
- [DailyFolderSwitch.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-dailyfolderswitch-md)
- [Default Schedule.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-default-schedule-md)
- [Wed Schedule.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-wed-schedule-md)
- [Friday Schedule.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-friday-schedule-md)

This setup is definitely more complicated than it should be. When I eventually
redo this, I'll probably try to move the logic into one place. I will probably
just drop the folder switch and just figure out the schedule in a single
PowerShell command.

### Meeting Note

This note uses the pwsh script mentioned below to look up details about the
meeting (if the title started with `id_`). If it doesn't have that prefix, it
creates a simple note where I would add who attended and my own rough notes.
Because this is usually created from the link on my daily note, I have a clear
link between the two.

- [Meeting Note.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-meeting-note-md)

### Post

Very basic 5 W's template (Who, What, Why, When, Where). The special bit was
having the metadata "status" of `in-progress`. This means that if I didn't
finish it, it would show up in my daily note query. Once I posted it, I would
add the link to the URL metadata and change the status to `posted`.

- [Post.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-post-md)

### Status Report

This is a template that I haven't been using much lately, but I probably should
be. The goal of this was to create this every Friday. It has a dataview query
that would find all the items I marked with `Did::`. So in my daily note I could
add a line that said: `Did::Shutdown SCCM`. That would help me remember all the
things I did so I could add them to a weekly status report. I'm also a sucker
for a writing prompt which can help me make sure I'm shaping my communications
appropriately.

- [Status Report.md](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-status-report-md)

## Using PowerShell

As a PowerShell ***enthusiast***, I wanted to write some scripts and easily add
the results to my notes. See above to read how I used them to pull in data.

- [pwsh.js](https://gist.github.com/HeyItsGilbert/8d492ebc7ad9c4830c0ae1fcc8fc6ac8#file-pwsh-js)

While the script is helpful to call PowerShell, the real magic is in the
PowerShell commands.

- `Get-MeetingSummary` would query the graph for my meetings.
- `Get-ObsidianSchedule` takes the data from `Get-MeetingSummary` and turns it
  into the appropriate markdown output. The command also creates a link to the
  video call and a link to create a [meeting note](#meeting-note) note.
- `Get-MeetingInfo` let's you pass the meeting title to it and get info about
  the meeting such as whether it's a series and who is attending. This is used
  in the [meeting note](#meeting-note) template.

## Keep what works, ditch what doesn't

I've said this a few times, and I really mean it. What makes Obsidian such a
powerful tool is how we can each make it our own. Some people want longer notes
and others want shorter ones. If you explore the Personal Knowledge Management
(PKM) space you'll see that everyone has their own take. At the end of the day
the value should be for **you**. You won't get a promotion because you took 10x
more notes that someone else. But if you can navigate your notes in a more
efficient manner and track what matters to you, you'll set yourself up for
success.

I hope that you found something useful in this note. If you have suggestions or
want to share your take, please let me know in the comments! I'm always
interested in new approaches!
