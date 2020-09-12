Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A231C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47476207C3
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599938303;
	bh=olkkwReA0WnnyujkJTosl6pmaiCkRITwroNPcXsWv8Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gP5V680oy4QG/ZSr4pCZMKgP1kf+2xGXKLgUw62cXqMU5zJFX1Vw7gD0vVW0hXEn5
	 A5vEKXXjjirVUoOy1wESq8dVrYsijD3cuPNbbwFNZ+aBFii6qoV4AUuMXqHslnkNDY
	 RPUbJUk1BVAJfyvobUTakFbiM0sN25+0tgf3GGqQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgILTSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTSV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:18:21 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4087207C3;
        Sat, 12 Sep 2020 19:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599938300;
        bh=olkkwReA0WnnyujkJTosl6pmaiCkRITwroNPcXsWv8Y=;
        h=Date:From:To:Subject:From;
        b=FhwmZNGRtNmR6c4sE6Ee5eapq3hYQ/36/9Hl9PPN9QJLUAn+w0QcM+wrNhgqSj+WV
         p7p1mltTWWwGyWVnIM7uw77W4ngg4OShwnWtbbROaNVzGr+S/XuFJu81v2Xz5DAkon
         og1A9JBV4JWIv6GTK2X5QNlnxdoOEBMRqVWCN2J0=
Date:   Sat, 12 Sep 2020 12:18:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + mm-memoryc-fix-spello-of-function.patch added to -mm tree
Message-ID: <20200912191820.msyD6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix spello of "function"
has been added to the -mm tree.  Its filename is
     mm-memoryc-fix-spello-of-function.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-fix-spello-of-function.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-fix-spello-of-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memory.c: fix spello of "function"

Fix typo/spello of "function".

Link: https://lkml.kernel.org/r/e7bf180e-c558-b1d5-9a15-6d9708823c9c@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-fix-spello-of-function
+++ a/mm/memory.c
@@ -3608,7 +3608,7 @@ static vm_fault_t do_set_pmd(struct vm_f
 
 /**
  * alloc_set_pte - setup new PTE entry for given page and add reverse page
- * mapping. If needed, the fucntion allocates page table or use pre-allocated.
+ * mapping. If needed, the function allocates page table or use pre-allocated.
  *
  * @vmf: fault environment
  * @page: page to map
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch
x86-numa-add-nohmat-option-fix.patch
mm-memoryc-fix-spello-of-function.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch
lib-mpi-fix-spello-of-functions.patch

