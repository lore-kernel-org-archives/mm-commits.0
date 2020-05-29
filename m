From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: incoming
Date: Fri, 29 May 2020 13:31:39 -0700
Message-ID: <20200529133139.c606b0e34255336d97af2b30@linux-foundation.org>
References: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
        <CAHk-=whQSWcE1WvKxptHdyc9BUXQyxxyAH954=Jb_YSBrNJYDQ@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgE2Ubl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 May 2020 16:31:41 -0400
In-Reply-To: <CAHk-=whQSWcE1WvKxptHdyc9BUXQyxxyAH954=Jb_YSBrNJYDQ@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>

On Thu, 28 May 2020 13:10:18 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Hmm..
> 
> On Wed, May 27, 2020 at 10:20 PM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >  fs/binfmt_elf.c                |    2 +-
> >  include/asm-generic/topology.h |    2 +-
> >  include/linux/mm.h             |   19 +++++++++++++++----
> >  mm/khugepaged.c                |    1 +
> >  mm/z3fold.c                    |    3 +++
> >  5 files changed, 21 insertions(+), 6 deletions(-)
> 
> I wonder how you generate that diffstat.
> 
> The change to <linux/mm.h> simply doesn't match what you sent me.  The
> patch you sent me that changed mm.h had this:
> 
>  include/linux/mm.h |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> (note 15 lines changed: it's +13 and -2) but now suddenly in your
> overall diffstat you have that
> 
>   include/linux/mm.h             |   19 +++++++++++++++----
> 
> with +15/-4.
> 
> So your diffstat simply doesn't match what you are sending. What's going on?
> 

Bah.  I got lazy (didn't want to interrupt an ongoing build) so I
generated the diffstat prior to folding two patches into a single one. 
Evidently diffstat isn't as smart as I had assumed!
