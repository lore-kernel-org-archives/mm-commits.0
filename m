Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB185C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1CC76113B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhKESd6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhKESd5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC5CE61108;
        Fri,  5 Nov 2021 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137077;
        bh=+tFiaMkUrGIorxH5OyD6U8viP4CWO3wdsQUZm8ZpUuk=;
        h=Date:From:To:Subject:From;
        b=AYWSwJHhq4RBkkTc7Yg5qnpZ3kTE6PWaytq4zIMmUr/7oJ/hsd8neKOz3wCbfqtBM
         BY09PlXODEbwmlsE7bwD+reH6WSN/If05y1L6vHrwJaj3P1uKSyQrGlzRqJiobtIwL
         xnAtPuPmTdYzsJgOe/5Vq4SzlrhHd29SU1J8gqms=
Date:   Fri, 05 Nov 2021 11:31:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hch@lst.de, jack@suse.cz,
        miquel.raynal@bootlin.com, mm-commits@vger.kernel.org,
        richard@nod.at, vigneshr@ti.com
Subject:  [folded-merged] mm-simplify-bdi-refcounting-fix-fix.patch
 removed from -mm tree
Message-ID: <20211105183117.uoI2tWMjP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-bdi-refcounting-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-simplify-bdi-refcounting-fix-fix.patch

This patch was dropped because it was folded into mm-simplify-bdi-refcounting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-simplify-bdi-refcounting-fix-fix

fix typo

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/backing-dev-defs.h~mm-simplify-bdi-refcounting-fix-fix
+++ a/include/linux/backing-dev-defs.h
@@ -104,7 +104,7 @@ struct wb_completion {
  * is tested for blkcg after lookup and removed from index on mismatch so
  * that a new wb for the combination can be created.
  *
- * Each bdi_writeback that is no embedded into the backing_dev_info must hold
+ * Each bdi_writeback that is not embedded into the backing_dev_info must hold
  * a reference to the parent backing_dev_info.  See cgwb_create() for details.
  */
 struct bdi_writeback {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-simplify-bdi-refcounting.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

