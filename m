Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573D1C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CF9564EFD
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCQWd2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 18:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhCQWdB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 18:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C896464F2A;
        Wed, 17 Mar 2021 22:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616020381;
        bh=QpRyt7uQeHK814r6WntnHQWc5szcG9ov4LFy44Ju0ug=;
        h=Date:From:To:Subject:From;
        b=B3FEH7QEmmKusVy5/BGUeWxPnk0N+Tqif/nStjD068pRAKqaCxUSi4LCmydr3eehi
         9rO0URqgjI0s/3m+HnqitVgY5RxmHokoMSPqhqJUIpx61sEELp0Y7N/1AIHw6auX7+
         1bJBkQ2m+Jay9geeb4RgB2U64GLpMYAmBJ+s38LY=
Date:   Wed, 17 Mar 2021 15:33:00 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  + mm-slab-fix-spelling-mistake-disired-desired.patch
 added to -mm tree
Message-ID: <20210317223300.hOo6Ya9_l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: fix spelling mistake "disired" -> "desired"
has been added to the -mm tree.  Its filename is
     mm-slab-fix-spelling-mistake-disired-desired.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slab-fix-spelling-mistake-disired-desired.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-fix-spelling-mistake-disired-desired.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/slab.c: fix spelling mistake "disired" -> "desired"

There is a spelling mistake in a comment. Fix it.

Link: https://lkml.kernel.org/r/20210317094158.5762-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c~mm-slab-fix-spelling-mistake-disired-desired
+++ a/mm/slab.c
@@ -2284,7 +2284,7 @@ void __kmem_cache_release(struct kmem_ca
  * Because if it is the case, that means we defer the creation of
  * the kmalloc_{dma,}_cache of size sizeof(slab descriptor) to this point.
  * And we eventually call down to __kmem_cache_create(), which
- * in turn looks up in the kmalloc_{dma,}_caches for the disired-size one.
+ * in turn looks up in the kmalloc_{dma,}_caches for the desired-size one.
  * This is a "chicken-and-egg" problem.
  *
  * So the off-slab slab descriptor shall come from the kmalloc_{dma,}_caches,
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-slab-fix-spelling-mistake-disired-desired.patch

