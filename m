From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: incoming
Date: Fri, 29 May 2020 14:12:34 -0700
Message-ID: <20200529141234.a77cdb556ea55a9b2514ef90@linux-foundation.org>
References: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
        <CAHk-=whQSWcE1WvKxptHdyc9BUXQyxxyAH954=Jb_YSBrNJYDQ@mail.gmail.com>
        <20200529133139.c606b0e34255336d97af2b30@linux-foundation.org>
        <CAHk-=wiU-vQVURz62dzitbh2Pk+m_+ipaJU6=z=ES3cd_wKSLQ@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbgE2VMf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 May 2020 17:12:35 -0400
In-Reply-To: <CAHk-=wiU-vQVURz62dzitbh2Pk+m_+ipaJU6=z=ES3cd_wKSLQ@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>

On Fri, 29 May 2020 13:38:35 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, May 29, 2020 at 1:31 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Bah.  I got lazy (didn't want to interrupt an ongoing build) so I
> > generated the diffstat prior to folding two patches into a single one.
> > Evidently diffstat isn't as smart as I had assumed!
> 
> Ahh. Yes - given two patches, diffstat just adds up the line number
> counts for the individual diffs, it doesn't count some kind of
> "combined diff result" line counts.

Stupid diffstat.  Means that basically all my diffstats are very wrong.
Thanks for spotting it.

I can fix that...
