Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EC4C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5533B61186
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhKDBu0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232399AbhKDBu0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Nov 2021 21:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6430611C8;
        Thu,  4 Nov 2021 01:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635990468;
        bh=KM3euH/F4Iv4p12CZfnop15yyTJoSvrNqzvD5DwbGrM=;
        h=Date:From:To:Subject:From;
        b=JAKOl4RJa0YCvs9CQVLu+BUI+2F3dG93u3YnX1rDGt3jDftWtf9OHoMSYQSulZJaY
         lNbV4fQrij59NG2JRoH/nLxG9z0uyWj9Ead4lg7ljoQjuigUiQ4mIIi8Kxm0bn+Gdh
         vmbYhKPrAFGlDplnUe+bjzLZ08mogZKIzCEVkyms=
Date:   Wed, 03 Nov 2021 18:47:48 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects-fix.patch removed from -mm
 tree
Message-ID: <20211104014748.8eLh96GIm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects-fix
has been removed from the -mm tree.  Its filename was
     linux-next-rejects-fix.patch

This patch was dropped because it is obsolete

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
linux-next-git-rejects.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

