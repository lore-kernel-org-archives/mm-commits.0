From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + sdhci-support-mmc_cap_mmc_highspeed.patch added to -mm tree
Date: Mon, 23 Aug 2010 13:25:23 -0700
Message-ID: <20100823132523.3436cc6c.akpm__20285.5543386706$1282595138$gmane$org@linux-foundation.org>
References: <201008232009.o7NK9LIf012151@imap1.linux-foundation.org>
	<20100823202258.GA6510@console-pimps.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab0HWUZ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 16:25:29 -0400
In-Reply-To: <20100823202258.GA6510@console-pimps.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: mm-commits@vger.kernel.org, zhangfei.gao@gmail.com, linux-mmc@vger.kernel.org, zgao6@marvell.com, Kyungmin Park <kyungmin.park@samsung.com>

On Mon, 23 Aug 2010 21:22:58 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> On Mon, Aug 23, 2010 at 01:09:21PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      sdhci: support MMC_CAP_MMC_HIGHSPEED
> > has been added to the -mm tree.  Its filename is
> >      sdhci-support-mmc_cap_mmc_highspeed.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > 
> > ------------------------------------------------------
> > Subject: sdhci: support MMC_CAP_MMC_HIGHSPEED
> > From: zhangfei gao <zhangfei.gao@gmail.com>
> > 
> > With MMC_CAP_MMC_HIGHSPEED, mmc & emmc could negotiate up to 50M,
> > otherwise only 25M could be reached.
> > 
> > Signed-off-by: Zhangfei Gao <zgao6@marvell.com>
> > Acked-by: Matt Fleming <matt@console-pimps.org> 
> > Cc: <linux-mmc@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Andrew, Kyungmin Park also ACK'd this.

Cool, thanks.

I'd scheduled these patches for 2.6.37 but if you guys have reasons why
you think they should go in earlier, please let me know.

These:

sdhci-support-mmc_cap_mmc_highspeed.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
sdhci-base-clock-freqency-change-in-spec-30.patch


