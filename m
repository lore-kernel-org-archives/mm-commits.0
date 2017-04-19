From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: acb32a95a9: BUG: kernel hang in test stage
Date: Wed, 19 Apr 2017 10:27:44 -0700
Message-ID: <20170419102744.077ca9821540db6dc0f1b439@linux-foundation.org>
References: <58f78acc.kZ0tk19VlXn2CBsV%fengguang.wu@intel.com>
        <20170419164602.GA4821@cmpxchg.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966094AbdDSR1q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2017 13:27:46 -0400
In-Reply-To: <20170419164602.GA4821@cmpxchg.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel test robot <fengguang.wu@intel.com>, mmotm auto import <mm-commits@vger.kernel.org>, LKP <lkp@01.org>, Linux Memory Management List <linux-mm@kvack.org>, wfg@linux.intel.com

On Wed, 19 Apr 2017 12:46:02 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hi,
> 
> On Thu, Apr 20, 2017 at 12:05:32AM +0800, kernel test robot wrote:
> > Greetings,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> > 
> > git://git.cmpxchg.org/linux-mmotm.git master
> > 
> > commit acb32a95a90a6f88860eb344d04e1634ebbc2170
> > Author:     mmotm auto import <mm-commits@vger.kernel.org>
> > AuthorDate: Thu Apr 13 22:02:16 2017 +0000
> > Commit:     Johannes Weiner <hannes@cmpxchg.org>
> > CommitDate: Thu Apr 13 22:02:16 2017 +0000
> > 
> >     linux-next
> 
> Hm, you'd think the linux-next commit in the mm tree would produce
> problems more often, but this is the first time I've seen it as the
> culprit in a problem report.
> 
> Do problems usually get spotted inside linux-next.git first and then
> the same issues are not reported against the -mm tree?
> 
> I also just noticed that <mm-commits@vger.kernel.org> might be a bad
> author email since AFAIK it drops everything but akpm-mail.

yup, that's how davem originally set it up.  It's never caused a
problem but it's a bit odd and I guess we could ask hmi to change it.

> Andrew,
> would it be better to set you as the Author of these import patches?
> Easy enough to change my scripts.

Sure, that works.
