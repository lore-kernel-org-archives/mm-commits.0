From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + zram-switch-to-crypto-compress-api.patch added to -mm tree
Date: Tue, 31 May 2016 19:01:44 -0700
Message-ID: <20160531190144.e092658b77298d964196f7b0@linux-foundation.org>
References: <574de1b2.LDeSluXYR1Ke9MvG%akpm@linux-foundation.org>
	<20160601012632.GE461@swordfish>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbcFACBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 22:01:45 -0400
In-Reply-To: <20160601012632.GE461@swordfish>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: sergey.senozhatsky@gmail.com, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Minchan Kim <minchan@kernel.org>, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 1 Jun 2016 10:26:32 +0900 Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:

> On (05/31/16 12:10), akpm@linux-foundation.org wrote:
> > The patch titled
> >      Subject: zram: switch to crypto compress API
> > has been added to the -mm tree.  Its filename is
> >      zram-switch-to-crypto-compress-api.patch
> > 
> > This patch should soon appear at
> >     http://ozlabs.org/~akpm/mmots/broken-out/zram-switch-to-crypto-compress-api.patch
> > and later at
> >     http://ozlabs.org/~akpm/mmotm/broken-out/zram-switch-to-crypto-compress-api.patch
> 
> Andrew,
> 
> I'd prefer this patch to also include changes from this one:
> http://ozlabs.org/~akpm/mmots/broken-out/zram-align-zcomp-interface-to-crypto-comp-api.patch
> (http://article.gmane.org/gmane.linux.kernel/2231316)
> 
> (per Minchan).
> 
> IOW, squash
>   http://ozlabs.org/~akpm/mmots/broken-out/zram-switch-to-crypto-compress-api.patch
>  and
>   http://ozlabs.org/~akpm/mmots/broken-out/zram-align-zcomp-interface-to-crypto-comp-api.patch

Done.
