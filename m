From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + mm-madvise-fix-freeing-of-locked-page-with-madv_free.patch
 added to -mm tree
Date: Fri, 25 Aug 2017 14:36:20 -0700
Message-ID: <20170825143620.582a8822f80431b4baacd8ee@linux-foundation.org>
References: <599df681.NreP1dR3/HGSfpCe%akpm@linux-foundation.org>
        <20170824060957.GA29811@dhcp22.suse.cz>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754764AbdHYVgV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 17:36:21 -0400
In-Reply-To: <20170824060957.GA29811@dhcp22.suse.cz>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: ebiggers@google.com, aarcange@redhat.com, dvyukov@google.com, hughd@google.com, minchan@kernel.org, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org, linux-mm@kvack.org

On Thu, 24 Aug 2017 08:09:57 +0200 Michal Hocko <mhocko@kernel.org> wrote:

> > Google Bug Id: 64696096
> 
> Is this necessary in the changelog?

I tend to keep this sort of a thing as a courtesy to the sender.

But I did change it from "Google-Bug-Id:". 
Documentation/process/submitting-patches.rst lists "Reported-by:,
Tested-by:, Reviewed-by:, Suggested-by: and Fixes:" as the recognized
patch tags and I don't think it's a good idea to introduce new ones -
that just creates more work for the people who maintain parsers for
this stuff.
