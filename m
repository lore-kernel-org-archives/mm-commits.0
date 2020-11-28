Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F953C64E7A
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 17:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36C2D246EC
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 17:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nY5M+zjv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732377AbgK1Rz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 28 Nov 2020 12:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732423AbgK1EVW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 23:21:22 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B105F22250;
        Sat, 28 Nov 2020 04:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606536630;
        bh=WS6NUCVkmet2g8OZrkRTVtIBQIjCUta3IxoaMDfrN1E=;
        h=Date:From:To:Subject:From;
        b=nY5M+zjvsYQUCTi0f9zrIEQy/sRiajutFG8lj1qiqBgG2oeeP5YEHGlEJDCXfq3yw
         xJ3c+GjfCjWA/azlyzQuaVuHUZLsehbkelNn1rOj7ztYcm2M0aD1KMCnXPaU9q3TZk
         PD3EP4HG0dCGEIVBR/mq97srGCYgf1MiSvE2z8d8=
Date:   Fri, 27 Nov 2020 20:10:30 -0800
From:   akpm@linux-foundation.org
To:     jrdr.linux@gmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, shihaitao1@huawei.com
Subject:  + mm-fix-some-spelling-mistakes-in-comments.patch added
 to -mm tree
Message-ID: <20201128041030.5Z7IOTK61%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some spelling mistakes in comments
has been added to the -mm tree.  Its filename is
     mm-fix-some-spelling-mistakes-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-some-spelling-mistakes-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-some-spelling-mistakes-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haitao Shi <shihaitao1@huawei.com>
Subject: mm: fix some spelling mistakes in comments

Fix some spelling mistakes in comments:
	udpate ==> update
	succesful ==> successful
	exmaple ==> example
	unneccessary ==> unnecessary
	stoping ==> stopping
	uknown ==> unknown

Link: https://lkml.kernel.org/r/20201127011747.86005-1-shihaitao1@huawei.com
Signed-off-by: Haitao Shi <shihaitao1@huawei.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c     |    2 +-
 mm/huge_memory.c |    2 +-
 mm/khugepaged.c  |    2 +-
 mm/memblock.c    |    2 +-
 mm/migrate.c     |    2 +-
 mm/page_ext.c    |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/filemap.c
@@ -1359,7 +1359,7 @@ static int __wait_on_page_locked_async(s
 	else
 		ret = PageLocked(page);
 	/*
-	 * If we were succesful now, we know we're still on the
+	 * If we were successful now, we know we're still on the
 	 * waitqueue as we're still under the lock. This means it's
 	 * safe to remove and return success, we know the callback
 	 * isn't going to trigger.
--- a/mm/huge_memory.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/huge_memory.c
@@ -2393,7 +2393,7 @@ static void __split_huge_page_tail(struc
 	 * Clone page flags before unfreezing refcount.
 	 *
 	 * After successful get_page_unless_zero() might follow flags change,
-	 * for exmaple lock_page() which set PG_waiters.
+	 * for example lock_page() which set PG_waiters.
 	 */
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
--- a/mm/khugepaged.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/khugepaged.c
@@ -1285,7 +1285,7 @@ static int khugepaged_scan_pmd(struct mm
 			 * PTEs are armed with uffd write protection.
 			 * Here we can also mark the new huge pmd as
 			 * write protected if any of the small ones is
-			 * marked but that could bring uknown
+			 * marked but that could bring unknown
 			 * userfault messages that falls outside of
 			 * the registered range.  So, just be simple.
 			 */
--- a/mm/memblock.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/memblock.c
@@ -871,7 +871,7 @@ int __init_memblock memblock_physmem_add
  * @base: base address of the region
  * @size: size of the region
  * @set: set or clear the flag
- * @flag: the flag to udpate
+ * @flag: the flag to update
  *
  * This function isolates region [@base, @base + @size), and sets/clears flag
  *
--- a/mm/migrate.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/migrate.c
@@ -2594,7 +2594,7 @@ static bool migrate_vma_check_page(struc
 		 * will bump the page reference count. Sadly there is no way to
 		 * differentiate a regular pin from migration wait. Hence to
 		 * avoid 2 racing thread trying to migrate back to CPU to enter
-		 * infinite loop (one stoping migration because the other is
+		 * infinite loop (one stopping migration because the other is
 		 * waiting on pte migration entry). We always return true here.
 		 *
 		 * FIXME proper solution is to rework migration_entry_wait() so
--- a/mm/page_ext.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/page_ext.c
@@ -34,7 +34,7 @@
  *
  * The need callback is used to decide whether extended memory allocation is
  * needed or not. Sometimes users want to deactivate some features in this
- * boot and extra memory would be unneccessary. In this case, to avoid
+ * boot and extra memory would be unnecessary. In this case, to avoid
  * allocating huge chunk of memory, each clients represent their need of
  * extra memory through the need callback. If one of the need callbacks
  * returns true, it means that someone needs extra memory so that
_

Patches currently in -mm which might be from shihaitao1@huawei.com are

mm-fix-some-spelling-mistakes-in-comments.patch

