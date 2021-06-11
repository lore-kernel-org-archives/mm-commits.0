Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805F2C48BE0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 20:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5882A613C6
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 20:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhFKUiA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 16:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229951AbhFKUh7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 16:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88571613AD;
        Fri, 11 Jun 2021 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623443761;
        bh=e5UIKZmZJEGeVPKspJLM7JXRj+Tfk1AyNooPwqyKF7U=;
        h=Date:From:To:Subject:From;
        b=NPAoUnfChUC+voRnbBPn2GURijkzH2Pq6FDIq37be850dpdoI8bMbCZrpVpMHdAi8
         N2QmEk/zqvUPybkz6lIJSUsRMAT7aC7zmBVFrLwICVgyFCCETkOU2plhYcA8Fpvv5i
         WKVGt7B9rpUXEgRbXd5XJxkjsexPezAYXR9q4Pso=
Date:   Fri, 11 Jun 2021 13:36:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210611203601.g6KQ0ATCF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/surface/surface_aggregator_registry.c |   17 ----------
 1 file changed, 17 deletions(-)

--- a/drivers/platform/surface/surface_aggregator_registry.c~linux-next-git-rejects
+++ a/drivers/platform/surface/surface_aggregator_registry.c
@@ -147,23 +147,6 @@ static const struct software_node *ssam_
 	NULL,
 };
 
-<<<<<<< HEAD
-/* Devices for Surface Laptop 1. */
-static const struct software_node *ssam_node_group_sl1[] = {
-	&ssam_node_root,
-	&ssam_node_tmp_pprof,
-	NULL,
-};
-
-/* Devices for Surface Laptop 2. */
-static const struct software_node *ssam_node_group_sl2[] = {
-	&ssam_node_root,
-	&ssam_node_tmp_pprof,
-	NULL,
-};
-
-=======
->>>>>>> linux-next/akpm-base
 /* Devices for Surface Laptop 3 and 4. */
 static const struct software_node *ssam_node_group_sl3[] = {
 	&ssam_node_root,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

