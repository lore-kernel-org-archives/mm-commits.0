From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + add-iscsi-ibft-support-v046.patch added to -mm tree
Date: Fri, 1 Feb 2008 10:23:56 -0800
Message-ID: <20080201102356.d7c4398e.akpm@linux-foundation.org>
References: <200801302201.m0UM1FeE027011@imap1.linux-foundation.org>
	<200802010942.49964.konrad@darnok.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbYBASY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 13:24:57 -0500
In-Reply-To: <200802010942.49964.konrad@darnok.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: mm-commits@vger.kernel.org, James.Bottomley@hansenpartnership.com, konradr@linux.vnet.ibm.com, michaelc@cs.wisc.edu, pjones@redhat.com, Greg KH <greg@kroah.com>

On Fri, 1 Feb 2008 09:42:47 -0500 Konrad Rzeszutek <konrad@darnok.org> wrote:

> On Wednesday 30 January 2008 17:01:14 akpm@linux-foundation.org wrote:
> > The patch titled
> >      Add iSCSI iBFT support (v0.4.6)
> > has been added to the -mm tree.  Its filename is
> >      add-iscsi-ibft-support-v046.patch
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> 
> Andrew, could you please at your earliest convenient time merge this patch 
> into Linus tree? Greg KH mentioned that since this patch depends on things in 
> his tree and Ingo's tree you are the one to ask for this.

OK.  Is everyone happy with it?  I don't seem to have accumulated any
Acked-by:'s or Reviewed-by:'s here.

> ... snip ..
> >
> > Patches currently in -mm which might be from konrad@darnok.org are
> >
> > add-iscsi-ibft-support-v045.patch
> 
> And remove the v045.patch as it is obsolete.
> 
> > add-iscsi-ibft-support-v046.patch
> > add-iscsi-ibft-support-v046-fix.patch
> 

I queued 046 as an incremental patch against 045 so I could see what
changed.  As a matter of routine I will fold the three patches together
prior to sending to Linus (or to a subsystem maintainer).
