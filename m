Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75198C433E3
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E2B161999
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC1TLp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231480AbhC1TLg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04C026197E;
        Sun, 28 Mar 2021 19:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958696;
        bh=AkZb8DdBrJ5QwZwH09IHI6UDAzWGQ+pLN9wSzP1+cxU=;
        h=Date:From:To:Subject:From;
        b=yEbajZxO1AoaZXlYm1DPWM0tdKy0LCqZnNg54IGZN9DyCreRqEzcK3QAqsfivp+Dz
         TI6UZVB9qzuy07SXUVfu8RZMbEK3s/V+8j4vtwfASZxqCFKzqXrcw7AFhoJGPs9tcj
         xiTOZZFOI6nueDw1k2H7k++5G6uUyAF8Q8dQP2iA=
Date:   Sun, 28 Mar 2021 12:11:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, unixbhaskar@gmail.com
Subject:  + lib-genallocc-fix-a-typo.patch added to -mm tree
Message-ID: <20210328191135.WLh86TtSb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: Fix a typo
has been added to the -mm tree.  Its filename is
     lib-genallocc-fix-a-typo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-genallocc-fix-a-typo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-genallocc-fix-a-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: lib/genalloc.c: Fix a typo

s/macthing/matching/

Link: https://lkml.kernel.org/r/20210326131530.30481-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/genalloc.c~lib-genallocc-fix-a-typo
+++ a/lib/genalloc.c
@@ -735,7 +735,7 @@ EXPORT_SYMBOL(gen_pool_first_fit_order_a
 
 /**
  * gen_pool_best_fit - find the best fitting region of memory
- * macthing the size requirement (no alignment constraint)
+ * matching the size requirement (no alignment constraint)
  * @map: The address to base the search on
  * @size: The bitmap size in bits
  * @start: The bitnumber to start searching at
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
ocfs2-fix-a-typo.patch
mm-kmemleak-fix-a-typo.patch
mm-typo-fix-in-the-file-utilc.patch
lib-fix-a-typo-in-the-file-bchc.patch
lib-genallocc-fix-a-typo.patch
ipc-semc-mundane-typo-fixes.patch
mm-few-spelling-fixes.patch
kernel-fix-a-typo-in-the-file-upc.patch
ipc-semc-couple-of-spelling-fixes.patch

