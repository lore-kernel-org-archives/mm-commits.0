Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD58C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D0D61424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhEHWlJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWlI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79C51613EA;
        Sat,  8 May 2021 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513606;
        bh=MmHUNb93lsoPK6GBGlo7ZM1hLH96y6iTeJYXj0zhWqA=;
        h=Date:From:To:Subject:From;
        b=xJAKgjC//a1pDZerrxrQq2EEf+Osdr+VGDPOnNz7qr1p4JzPy2iWiLjy3NsQ5bJBH
         6v5zgjqsUybKlmj3va7/+iEHN1TWEw3XSBJqnWqzxWBqRYqzpRiMiM0Xd5Wg+7jS8i
         OXiikehotVSSXtR+S36Blq3W/wOtVNmFdMCpSbB8=
Date:   Sat, 08 May 2021 15:40:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  [merged] mm-kmemleak-fix-a-typo.patch removed from -mm
 tree
Message-ID: <20210508224006.u6wB20tjm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak.c: fix a typo
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-fix-a-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: mm/kmemleak.c: fix a typo

s/interruptable/interruptible/

Link: https://lkml.kernel.org/r/20210319214140.23304-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-a-typo
+++ a/mm/kmemleak.c
@@ -1203,7 +1203,7 @@ static void update_refs(struct kmemleak_
 }
 
 /*
- * Memory scanning is a long process and it needs to be interruptable. This
+ * Memory scanning is a long process and it needs to be interruptible. This
  * function checks whether such interrupt condition occurred.
  */
 static int scan_should_stop(void)
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


