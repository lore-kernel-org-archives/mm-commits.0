From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + x86-mm-account-for-tlb-flushes-only-when-debugging-fix.patch
 added to -mm tree
Date: Fri, 17 Jan 2014 14:49:35 -0800
Message-ID: <20140117144935.69021c83b48b7c567c0c0ac3@linux-foundation.org>
References: <52d9a3a4.LiqUO9AdPVRNTEv+%akpm@linux-foundation.org>
	<52D9A460.5030803@zytor.com>
	<alpine.LSU.2.11.1401171432020.2665@eggly.anvils>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaAQWti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jan 2014 17:49:38 -0500
In-Reply-To: <alpine.LSU.2.11.1401171432020.2665@eggly.anvils>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mm-commits@vger.kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, davidlohr@hp.com, alex.shi@linaro.org, mgorman@suse.de, rientjes@google.com

On Fri, 17 Jan 2014 14:43:05 -0800 (PST) Hugh Dickins <hughd@google.com> wrote:

> On Fri, 17 Jan 2014, H. Peter Anvin wrote:
> > On 01/17/2014 01:41 PM, akpm@linux-foundation.org wrote:
> > > From: Mel Gorman <mgorman@suse.de>
> > > Subject: x86-mm-account-for-tlb-flushes-only-when-debugging-fix
> > > 
> > > there are times when I am a complete muppet
> > > 
> > 
> > You know... this is a very succinct patch description, but in isolation
> > it seems a bit vague, no?  ;)
> 
> Indeed, we need a full schedule for when Mel is a muppet and when not.

You need to cater for semimuppetude.

> And one of the times would be when he wrote
> 
> > Reported-by: Hugh Dickins <hughd@google.com>
> 
> which came as a surprise to me, I thought my Alzheimer's was acting up.

That would be me getting my patches confused.  Already fixed!

> But I think he meant my esteemed colleague
> 
> Reported-by: David Rientjes <rientjes@google.com>
> 
> Not that either of us will mind much: it's the patch that matters,
> and it will all get squashed into what it fixes anyway.

yup.
