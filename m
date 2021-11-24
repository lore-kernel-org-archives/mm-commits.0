Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11488C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345380AbhKXW5A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244991AbhKXW46 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Nov 2021 17:56:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212ECC061574
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 14:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7OhyfzTMfxB3WIhx1Xn2Wy5eSnt7+wGdjq83v+8P1/g=; b=zjGOExXBf0T0xIpS3zO2B1nioe
        fvNw/HkEEb2x8s7F40xuaxmBertw6COMt9p18VY17ICq6ZgJc2X2Za8eBhJzYiBsP6V+CNSf9XYf+
        BHX/kDwboCzzyk6s2Y722AQFufrK8e9oZq738lQn8SSE27q499kZ8/yKYMjxS8Dj0pv48rP9AvmuX
        5xVPeMWPKWgGeTrrDBd8uigCYzDnZIt0ULERlc6RkG4OCaE62YazI/8vZj32raVsSsySDRpfLoLxt
        nF3gVXIFUel+LM2YdxuVZNYW6TasGdJrE4w5aJydw5YUeAiF3n03pvi9JcuglAbWeBFZSogQKCAbm
        7RrkF6xA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mq197-005zYs-Ln; Wed, 24 Nov 2021 22:53:45 +0000
Date:   Wed, 24 Nov 2021 14:53:45 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     akpm@linux-foundation.org
Cc:     jack@suse.cz, mm-commits@vger.kernel.org
Subject: Re: +
 inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
 added to -mm tree
Message-ID: <YZ7CeYrk6JVMabz3@bombadil.infradead.org>
References: <20211124220909.SFQ1gvukm%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124220909.SFQ1gvukm%akpm@linux-foundation.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Nov 24, 2021 at 02:09:09PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: inotify-simplify-subdirectory-registration-with-register_sysctl-fix
> has been added to the -mm tree.  Its filename is
>      inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Luis Chamberlain <mcgrof@kernel.org>
> Subject: inotify-simplify-subdirectory-registration-with-register_sysctl-fix
> 
> remember to register fanotify_table
> 
> Link: https://lkml.kernel.org/r/YZ5A6iWLb0h3N3RC@bombadil.infradead.org
> Reported-by: Jan Kara <jack@suse.cz>

Feel free to add my SOB

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 Luis
