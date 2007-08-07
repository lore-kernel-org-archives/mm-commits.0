From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
 added to -mm tree
Date: Tue, 7 Aug 2007 13:19:49 -0700
Message-ID: <20070807131949.fa060048.akpm@linux-foundation.org>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
	<1186179369.13852.36.camel@localhost>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763AbXHGUVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:21:01 -0400
In-Reply-To: <1186179369.13852.36.camel@localhost>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com, jeff@garzik.org

On Fri, 03 Aug 2007 15:16:09 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2007-08-03 at 17:05 +0200, Jean Delvare wrote: 
> > Fine with me, but this first patch should still be correct per se.
> 
> Add new pr_<level> printk(KERN_<level> fmt "\n", ##arg) to kernel.h
> pr_info and pr_debug are unchanged
> Remove local pr_err #defines
> Convert current uses of pr_err

OK, I've lost the plot here.  If we have now converged on an
agreeable patch, please resend it?
