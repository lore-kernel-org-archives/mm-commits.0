Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E57BC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C5B161424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhEHWx5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhEHWx5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A39461402;
        Sat,  8 May 2021 22:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514375;
        bh=J6lHXi6yoamUvf80DwBxLYraCNNRxWfQOk1S4RDxx60=;
        h=Date:From:To:Subject:From;
        b=f6etplPBKnxMV2VESs2RmJynu8epF3v+4bEd4AgbF+PZXs1DnAM86XmptESxQsA8d
         i0YG3Y05UXBA5M2EwZ0QHA1T7INtTEwavdLhA+LVzf76lnz9WV/bF17uPHhS/oTvO7
         a5/DTWQC9ExI/7qcrx2YA0Cp3y+EIv7s12Zn7dRE=
Date:   Sat, 08 May 2021 15:52:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, unixbhaskar@gmail.com
Subject:  [merged] lib-genallocc-fix-a-typo.patch removed from -mm
 tree
Message-ID: <20210508225255.jULGLEUKK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: fix a typo
has been removed from the -mm tree.  Its filename was
     lib-genallocc-fix-a-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


