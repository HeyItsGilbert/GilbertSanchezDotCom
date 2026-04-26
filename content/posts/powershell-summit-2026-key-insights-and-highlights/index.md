---
title: "PowerShell Summit 2026: Key Insights and Highlights"
date: 2026-04-26T21:47:58.943Z
description: Three talks, two releases, one live domain purchase, and a lot of feelings about neurodiversity. My recap of PowerShell Summit 2026.
summary: Three talks, two major releases, one domain bought live on stage - here's what happened at PowerShell Summit 2026 and what stayed with me.
showReadingTime: true
draft: false
preview: feature.jpg
lastmod: 2026-04-26T22:59:14.141Z
slug: powershell-summit-2026
tags:
    - FOSS
    - PowerShell
    - Presentation
keywords:
    - PowerShell Summit 2026
    - PowerShell Summit recap
    - psake v5
    - Plaster v2
    - neurodiversity in tech
    - ADHD developer
    - FOSS sustainability
    - MCP servers PowerShell
    - Hugo static site
    - Chocolatey automation
series: []
type: posts
fmContentType: posts
---

{{< lead >}}
"I am what the kids call spicy brained."
{{< /lead >}}

This is how I broke the ice on my author slide. I mentioned that I was diagnosed
as an adult with ADHD — partly because I blog about it, and partly because it
was [Neurodiversity Celebration
Week](https://www.neurodiversityweek.com/events-2026). While my talks ranged
from Open Source organization (as a way to avoid burnout) to Static Site
generation (where I allowed my ADHD to run rampant - I bought a domain LIVE 😱),
the through line was about people and sustainability. But it was also about
inviting people into the space and letting them be themselves.

If you've never heard of Summit, aka PowerShell + DevOps Global Summit, it's a
yearly conference in Seattle where folks come from around the world to talk
about PowerShell and DevOps. This year I gave three talks, announced two major
module releases, and kicked off a new org effort. Unsurprisingly, the AI buzz
was immediate -- five minutes into the Sunday night reception, it was already
the dominant topic. Lots of good conversation with folks at all points in their
careers, openly sharing concerns and curiosity in equal measure.

## The Talks

{{< carousel images="{GilbertPresenting.jpg,GilbertPresenting2.jpg}" >}}

### From Burnout to Built-to-Last

This talk was fundamentally about using organizations as a way to keep
maintainers (you!) from burning out. I covered red flags to watch for,
my journey with psake, and a huge (and incomplete!) list of free services for
FOSS orgs. I mentioned in my talk that I have ADHD -- and that's when I first
realized I'd uncovered something. After my talk, I was immediately approached
by folks to thank me for talking about being neurodiverse. On the way home, I
found out that Joshua Dearing had written something about it.

> Gilbert Sanchez gave a deeply relatable talk on neurodiversity and what he
> called the “open-source dopamine train.” It’s easy to get energized and ship a
> cool tool. It’s much harder to sustain it solo. The real takeaway was this: if
> you want to build something that lasts, build a community around it, not just
> a codebase. His talk left me genuinely motivated to get more involved in
> larger open-source projects. Which, for someone who showed up worried about
> cliques, feels like real progress.
> - Joshua Dearing [We're All Insane, and That's Our Superpower]

It got the most feedback of anything I presented, and all of it was positive.
The only critique: they wished it was longer. The impact became clear
throughout the rest of Summit, especially when we announced our revival effort.

### Stop Hand-Rolling Chocolate

This talk covered building Chocolatey packages with psake, but the real
undertone was sustainability. I started with a silly flashback montage of me
ripsticking down the hallways of the Facebook of yesteryear -- which quickly
set the stage for a small team of 6 managing hundreds of thousands of servers.
That team owned several core services, and packaging was a minor bullet point
in their list of priorities. And yet even an org with just 5 packages would
benefit from automation.

The other point I hammered home: "It's Just PowerShell". Chocolatey and psake
are both "just PowerShell" -- and what people criticize about PowerShell -- its
verbosity -- is really its feature. Any developer can read it, and "just PowerShell" means no
context switch or mental model shift.

This is where I got to finally announce that Psake v5 was just released. This
came in handy the following day when token cost was a key point in the State of
the Shell.

{{< github repo="psake/psake" showThumbnail=true >}}


### Markdown Madness (90 Minutes of Controlled Chaos)

This was my last talk -- fittingly on the last day. I had planned to take a
10-minute break, figuring the audience would appreciate it. But there was just
too much to cover. I told them they were about to witness my ADHD fully
unleashed, and that if given 90 minutes to fill, I would fill every last one.
I offered to take any and all suggestions, especially if it meant trying
something new. "What could go wrong? At least I'll have the YouTube video to
show my therapist." 25 slides in less than 25 minutes and then the chaos really
began. In what any sane person would consider ill-advised, I decided to do it
all live.

First it was painfully basic. GH pages with just markdown, no theme. Then we
used a GitHub template I had found the night before. I had never deployed it. I
didn't even read the readme... 😬. But I knew if people saw me figure it out
live, they could too.

From there, we set up Netlify (I signed up the night before because I thought
signing up would be boring to watch). I pointed Netlify to build the new
template repo and in a few minutes we had https://nicejekyll.netlify.app/.
Proof of concept locked in. So we moved on to the main event: buying a domain.

> I BOUGHT A DOMAIN IN FRONT OF EVERYONE!

"It's just so dumb it might just work" could have been the punchline of this
talk. Did I practice the flow of buying a domain? Nope. Did I check if my credit
card details would be exposed? Nope. Am I a smart man? Certainly doesn't sound
like it. But you know what? It worked flawlessly.

Then we logged into Cloudflare, added the domain for management, grabbed the
nameserver address, and set it on PorkBun (my registrar of choice). A few
seconds after pointing Cloudflare to Netlify, https://markdownmadness.lol was
up and running.

From there, we pivoted to how I publish Obsidian notes with Quartz. We briefly
covered Docusaurus, and Hugo got sprinkled in by request. I did hear the last
few minutes were a bit disorganized, but I think I'm okay with how it all
turned out.

Ironically, I had prepped Docker images and backup videos in case I lost
internet access ("If you're seeing this... my demos have failed."). But the
funniest part? It was easier to do it live! The audience got a real sense of
how approachable this stuff actually is -- no special knowledge required.
Whether they were enraptured from awe or horrified shock, I couldn't be sure. I did
inspire Frank Lesniak to buy a domain for his lightning demo project:
gloryrole.com

## The Hallways Are Half the Conference

If you've ever asked anyone who's been to Summit what their favorite talk was,
they'll say the hallway track. That's the unofficial name for all the
conversations you have in the hallways, at lunch, or after hours. You get to
meet folks from throughout the community, meet some of your heroes in person,
and talk shop. Lots of "aha!" moments and laughs.

{{< carousel images="{BarMondayNight.jpg,BarMondayNight2.jpg,GilbertChristian2.jpg,GilbertDJ.jpg,GilbertKevin.jpg,JeffreyGilbert.jpg,LastBreakfast.jpg,LateNightBar.jpg,TeamDinner.jpg,ThursdayNightDJTrent.jpg}" >}}

I had the pleasure of discussing AI with Jeffrey Snover. You may know him as a
prominent lobster roll food blogger[^1], but he also created PowerShell. Jeffrey
decided to come out of retirement to help [some law
school](https://www.jsnover.com/blog/2026/03/09/fellowship-at-harvard-law-school/)
think about AI. What made it special was the setting: a lunch table with folks from
across the community. I asked if he was familiar with the research that
Scott Hanselman and Mark Russinovich did on the Jr engineer pipeline. Jeffrey had
an interesting take: companies will start hiring people with degrees beyond CS --
law, philosophy, you name it -- because they come in with fresh eyes. They
aren't jaded like most of us who've dealt with off-by-one errors or case
sensitivity. At their core, these are systems problems, and that goes beyond
technology.

Tuesday night featured the after-dark sessions. The CMDlety session was run
like a game show and it was an absolute blast. As you're watching, you think,
"this isn't that hard!" "All you need to do is X." And then you sit on the
podium with everyone watching you, using one of the weirdest keyboards (last
complaint about it, Christian, I promise), and boy does your brain just kernel
panic. Two minutes feels like a cakewalk to the observer, but when you're on
stage, it's never enough. I look forward to next year, where Team `$null` will get their revenge!

I got to chat with the PowerShell packaging team (Anam, Amber, and Aditya)
about some of our specific needs. The team across the board, from Jason Helmick
to Michael Green, mentioned that filing issues was how they got signal on what
the community needed. As a peace offering for annoying them with my constant
requests, I gave them all one of the limited pins I made for Summit.

Thursday evening, I caught up with Andrew and we recorded an episode covering
everything from the week. The title was aptly named ["The Hallway Track."]
ADHD came up as a core topic, as it had throughout Summit. I was really honored
that so many people felt seen, and in turn felt safe being themselves. People
came up after every one of my talks, caught me in hallways, stopped me in the
lunch line -- all to say thank you. I was moved that simply sharing who I am,
and making space for others, meant so much to so many.

## The AI Thread (It Was Everywhere)

Kellyn Gorman kicked things off with her keynote on Monday. The point I carried
through the whole week: teams with guardrails were the ones moving fastest. I
could say, with pride, that our team was already deep in. Trent Blackburn on my
team gave a talk on [AI Agent Instruction Modules (aka
AIM)](https://github.com/tablackburn/ai-agent-instruction-modules) which he
developed to keep instructions synced. It was great to see his work get so much
praise -- it's exactly what I point people to when they have questions. That
guardrail point kept proving itself, right down to how fast we shipped psake.

{{< github repo="tablackburn/ai-agent-instruction-modules" showThumbnail=true >}}


AI was the constant topic and that's no surprise in 2026. The surprise, I
thought, was that all the AI conversation was around MCP servers. I feel like AI
trends come and go fast:

- Prompt engineering
- MCP servers
- Skills
- Don't do any of those because of context rot
- Let the LLM generate a script for every action, because it's good at writing scripts
- ...and now MCP servers again

So MCP servers being the hot thing two trends later was surprising. Since then
I've seen some of the AI Engineering conference talks and I can see new and
interesting things coming on the MCP front.

While there were 3 talks about MCPs, each delivered something different. First
was Dongbo Wang from the PowerShell team, showing how to easily turn your
scripts into MCP tools. Kevin Marquette, a few sessions later, pivoted into more
concrete territory. His was the most practically useful for testing MCP servers,
and he covered far more of the protocol -- I walked away with real things to
explore. Rounding it out was Steven Murawski, who delivered the most
full-featured MCP PowerShell server. Dongbo and Kevin both shied away from
authentication (because it's difficult), but Steven's PoshMCP has OTEL and
OAuth out of the box.

Steven also talked about using Squads, a team of AI agents, to iterate quickly.
Agent teams are something I've been meaning to explore, and I've since built a
code-review skill with multiple agents (based on some of our favorite PS
community personalities -- i.e. "Shawn Weee-ler").

## Announcements Worth Marking Down

James Petty announced on day one that [Plaster
v2.0](https://www.powershell.org/plaster/) was officially released (as soon as I
fixed the build system 😬). This has been a long time coming. James added the
ability to use JSON instead of XML. I've floated the idea of YAML
and maybe someone will come by and ship that.

{{< github repo="PowerShellOrg/Plaster" showThumbnail=true >}}

In my Chocolatey package automation with psake talk, I announced that [psake v5.0]
was officially released as of that morning. When Michael Greene and Steve
Bucher brought up token cost during the State of the Shell, that became my
perfect hook -- because that's exactly what we shipped! Psake v5 focused on
improving token usage and giving clear errors to both users and LLMs (including
full error objects). I may dig into that in a future post.

On Thursday, just before Snover came on stage for his final talk, I announced
that we were starting a new effort in the PowerShell Org: reviving core modules
that had gone dark. We're starting with
[PSDepend](https://github.com/PowerShellOrg/PSDepend) with the help of Warren
Frame (aka PSCookieMonster). This follows my talk on running organizations
sustainably, so it felt right. We invited everyone to swing by at lunch to learn
how to get involved. Since then, I've put together a governance model, an issue
template, and set up the communication channels. Keep an eye out for a future
post about how I set that up.

{{< github repo="PowerShellOrg/PSDepend" showThumbnail=true >}}

## The Part That Stays With Me

Summit was an absolute blast (it always is). By Friday, I was absolutely spent.
And there's still so much to do. But the thing is, there always is.

> I took two weeks off and I feel like I can never catch up. - Coworker

This was something a coworker told me when I got back. I told him, "Catching up
is make-believe." The work will always be there. If you had a magic wand that
cleared your entire backlog, the list wouldn't stay empty for long. You just
have to prioritize and learn when to say no (which is easier said than done).
But the real magic will always be the people: the late night DJ set with your
teammate, the stand up where you laugh about a funny moment from the conference,
the little phrase that lives on for years ("get'em louis!").

I released two major versions of community projects, talked with Jeffrey Snover
about AI, and announced the PowerShell Org revival effort to a room full of
people. But what will really stay with me are all the moments someone stopped
me to say thank you for talking openly about being neurodiverse. Honestly, I've
been humbled by every kind word. So to everyone who worries about being
themselves, or fears they might not be accepted:

You're not alone and you can talk about it.

[^1]: I swear there was a period that Jeffrey was posting Lobster Roll photos regularly, but I can't find any proof. But I am committed to this bit until I am told I'm hallucinating.

[We're All Insane, and That's Our Superpower]: https://www.dearing.dev/posts/We're-All-Insane,-and-That's-Our-Superpower/#beyond-code-the-human-side-of-insanity
["The Hallway Track."]: https://www.pdq.com/resources/the-powershell-podcast/the-powershell-summit-hallway-track-with-gilbert-sanchez-and-joshua-dearing/
[psake v5.0]: https://psake.dev/blog/psake-5-0-0-released