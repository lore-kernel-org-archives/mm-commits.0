Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F19C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 00:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9FC0610C7
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 00:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhJ1ANS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 20:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhJ1ANR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 20:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B062C610C7;
        Thu, 28 Oct 2021 00:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635379851;
        bh=llB2x4PumpxJH1M+y8/KWq0x9mbCYt6zSP4hXxrT3Sc=;
        h=Date:From:To:Subject:From;
        b=0Y2lQyuJ7rujlSKRxhukHT2Sv2FkNEFBU+SVvg1RDsuXDmWAT21QEwhvmZLou/GXe
         6xzAPQLfIjXOvl87iaheTD0s4C+BxEZdqeEmLJkBbsnPiStcK3/KYPW+tWe0xVyetv
         cW4pXTAYuwOqY+jC298lyPMai+k/b2riKj8DK+1g=
Date:   Wed, 27 Oct 2021 17:10:51 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects-fix.patch added to -mm tree
Message-ID: <20211028001051.wlG-XE8Mh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects-fix
has been added to the -mm tree.  Its filename is
     linux-next-rejects-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects-fix.patch

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
Subject: linux-next-rejects-fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c~linux-next-rejects-fix
+++ a/lib/bootconfig.c
@@ -50,7 +50,7 @@ static inline void * __init xbc_alloc_me
 
 static inline void __init xbc_free_mem(void *addr, size_t size)
 {
-	memblock_free_ptr(addr, size);
+	memblock_free(addr, size);
 }
 
 #else /* !__KERNEL__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-move-kvmalloc-related-functions-to-slabh-fix.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
mm-simplify-bdi-refcounting-fix-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
linux-next-rejects.patch
linux-next-rejects-fix.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch

