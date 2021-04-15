Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10528C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 01:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A8A6117A
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 01:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhDOBKm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Apr 2021 21:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhDOBKl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Apr 2021 21:10:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E4761155;
        Thu, 15 Apr 2021 01:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618449019;
        bh=aAMBcGnmtk7keo+lj6OHcZRa5zk6aQXjcfOUjo+QAtY=;
        h=Date:From:To:Subject:From;
        b=f6wDnMrZecNCXebmpRWb66U5xk5vFQNJQezT9HKHZ7VbIOYpw/Lmx3c3vaYpB0zXa
         TiFOuBB+kTueaI1pgdzcNo8wGOQSmvnV/ToAOgBXLIxlBnGvf5ur5nkzT64Iw8OnwH
         OAUPX1Lgyxmjag0cWk/TXAn5i7oXDWOWwTLsF4Q0=
Date:   Wed, 14 Apr 2021 18:10:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210415011018.BuFuQzz4Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/word-at-a-time.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/arm64/include/asm/word-at-a-time.h~linux-next-git-rejects
+++ a/arch/arm64/include/asm/word-at-a-time.h
@@ -54,11 +54,8 @@ static inline unsigned long find_zero(un
 static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret, tmp;
-<<<<<<< HEAD
-=======
 
 	__uaccess_enable_tco_async();
->>>>>>> linux-next/akpm-base
 
 	/* Load word from unaligned pointer addr */
 	asm(
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

