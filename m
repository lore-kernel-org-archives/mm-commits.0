Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEFAC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57ADA610FA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhEHW4A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhEHW4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B21B6142D;
        Sat,  8 May 2021 22:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514498;
        bh=YurC2Q/NdpiTuqmisUQSLYp2FwHSQR/3sbzT4kiufA4=;
        h=Date:From:To:Subject:From;
        b=lNrwMzklAhZUjYCficzlwx0I3ijUFIKl0YktyZyntwrI///rIJRGCYn6skDCESqYH
         1qIJSKRngIiu24SwPeuUokaQKDyCqlE4kAoLnrL7oMoaKV9UhtwFpYSlZLoKCBtrrX
         eEZAWiJMVH4aQO7yz/5FgaegAUccEhq594RuuSrg=
Date:   Sat, 08 May 2021 15:54:58 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-slab-fix-spelling-mistake-disired-desired.patch removed from -mm tree
Message-ID: <20210508225458.0N7afFp5q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: fix spelling mistake "disired" -> "desired"
has been removed from the -mm tree.  Its filename was
     mm-slab-fix-spelling-mistake-disired-desired.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


