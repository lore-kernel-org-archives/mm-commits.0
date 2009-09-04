From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [alternative-merged]
 aoe-ensure-we-initialise-the-request_queue-correctly.patch removed from -mm
 tree
Date: Fri, 4 Sep 2009 09:05:00 -0700
Message-ID: <20090904090500.c2929300.akpm@linux-foundation.org>
References: <200909032027.n83KRDwt006246@imap1.linux-foundation.org>
	<8917b63c0464303818acf3117236f999@coraid.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631AbZIDQFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 12:05:33 -0400
In-Reply-To: <8917b63c0464303818acf3117236f999@coraid.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Ed Cashin <ecashin@coraid.com>
Cc: apw@canonical.com, bonbons@linux-vserver.org, jens.axboe@oracle.com, martin.petersen@oracle.com, rjw@sisk.pl, mm-commits@vger.kernel.org

On Fri, 4 Sep 2009 08:22:17 -0400 Ed Cashin <ecashin@coraid.com> wrote:

> On Thu Sep  3 16:29:12 EDT 2009, akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      aoe: ensure we initialise the request_queue correctly
> > has been removed from the -mm tree.  Its filename was
> >      aoe-ensure-we-initialise-the-request_queue-correctly.patch
> > 
> > This patch was dropped because an alternative patch was merged
> > 
> > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> I'm having trouble finding the alternative patch that was merged.  I
> don't see it in Linus's tree or in broken out mmotm.

I seem to have confused myself, sorry.

>  Does the new
> patch incorporate Jens Axboe's suggestion to use blk_queue_alloc
> instead of blk_queue_init?
> 

No, I don't think I've seen a patch which includes that.
