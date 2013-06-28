From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2013-06-27-16-36 uploaded
Date: Thu, 27 Jun 2013 17:32:25 -0700
Message-ID: <20130627173225.3915d976.akpm__43257.7371401296$1372379590$gmane$org@linux-foundation.org>
References: <20130627233733.BAEB131C3BE@corp2gmr1-1.hot.corp.google.com>
	<20130628095712.120bec7036284584fd467ee2@canb.auug.org.au>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3F1Acs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jun 2013 20:32:48 -0400
In-Reply-To: <20130628095712.120bec7036284584fd467ee2@canb.auug.org.au>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org

On Fri, 28 Jun 2013 09:57:12 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Thu, 27 Jun 2013 16:37:33 -0700 akpm@linux-foundation.org wrote:
> >
> > The mm-of-the-moment snapshot 2013-06-27-16-36 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> >   include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
> >   arch-c6x-mm-include-asm-uaccessh-to-pass-compiling.patch
> >   drivers-dma-pl330c-fix-locking-in-pl330_free_chan_resources.patch
> 
> Did you mean to drop these three patches from linux-next?

Nope, they should be inside the NEXT_PATCHES_START/NEXT_PATCHES_END
section, thanks.

