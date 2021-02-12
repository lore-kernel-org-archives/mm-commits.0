Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB0BC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3005264E4D
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhBLAFc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 19:05:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhBLAFc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 19:05:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EB2964E4A;
        Fri, 12 Feb 2021 00:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613088291;
        bh=Z5cCmBw++AVZWr0Mh+PW0lmmB4j1wdgmtsdd3tN4iS8=;
        h=Date:From:To:Subject:From;
        b=k4u/oKIhpE65rIeJJSRgbWjZ1A8Lasqzy3Egv9Q5I/Ymm8AP+aYsqdYi2j3X1rAmK
         qfem/DK1zI4TSAArGDkhRc8aVmtD08lYgNh4z5T94EWTW2D5MO5Y7F95A66zYpQLfQ
         ADsBIm4IqjP8ea84lkdYbjxPI4ZOv8BFvRvyK0dY=
Date:   Thu, 11 Feb 2021 16:04:51 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rientjes@google.com,
        daizhiyuan@phytium.com.cn
Subject:  + mm-slub-minor-coding-style-tweaks.patch added to -mm tree
Message-ID: <20210212000451.15N2f%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: minor coding style tweaks
has been added to the -mm tree.  Its filename is
     mm-slub-minor-coding-style-tweaks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-minor-coding-style-tweaks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-minor-coding-style-tweaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/slub: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1612847403-5594-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-minor-coding-style-tweaks
+++ a/mm/slub.c
@@ -3269,7 +3269,7 @@ void kmem_cache_free_bulk(struct kmem_ca
 		if (!df.page)
 			continue;
 
-		slab_free(df.s, df.page, df.freelist, df.tail, df.cnt,_RET_IP_);
+		slab_free(df.s, df.page, df.freelist, df.tail, df.cnt, _RET_IP_);
 	} while (likely(size));
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-slub-minor-coding-style-tweaks.patch
mm-hugetlbc-fix-typos-in-comments.patch

