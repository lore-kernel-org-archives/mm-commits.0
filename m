Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DC3C4708F
	for <mm-commits@archiver.kernel.org>; Wed,  2 Jun 2021 20:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09F80613DC
	for <mm-commits@archiver.kernel.org>; Wed,  2 Jun 2021 20:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhFBUud (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Jun 2021 16:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhFBUud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Jun 2021 16:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A332261040;
        Wed,  2 Jun 2021 20:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622666929;
        bh=4RBNoaKRvMrC7BxtevWxROef+KCyU3vuXVWPEY/LUDM=;
        h=Date:From:To:Subject:From;
        b=uA3jV5zozSJf29rf7TCic9Jmnl7BTC+k2GXnoQVMWE2IUxJSyYfKlGTGageHvZxDq
         i82dtJwK12Pd01rUaZWzt8TWTlh0XdvL3KIogGrbhJNiw8pgscl4jKuDutlU3UGf4l
         x2AfwGls7crV2WCjxEyz7gtvj/LVLvLxisgXmBJc=
Date:   Wed, 02 Jun 2021 13:48:49 -0700
From:   akpm@linux-foundation.org
To:     aisheng.dong@nxp.com, akpm@linux-foundation.org, bhe@redhat.com,
        dyoung@redhat.com, mm-commits@vger.kernel.org, vgoyal@redhat.com
Subject:  [folded-merged]
 mm-rename-the-global-section-array-to-mem_sections-fix.patch removed from
 -mm tree
Message-ID: <20210602204849.pTKD2VH__%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-the-global-section-array-to-mem_sections-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-the-global-section-array-to-mem_sections-fix.patch

This patch was dropped because it was folded into mm-rename-the-global-section-array-to-mem_sections.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rename-the-global-section-array-to-mem_sections-fix

update comment

Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Dong Aisheng <aisheng.dong@nxp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-rename-the-global-section-array-to-mem_sections-fix
+++ a/mm/sparse.c
@@ -20,7 +20,7 @@
 /*
  * Permanent SPARSEMEM data:
  *
- * 1) mem_section	- memory sections, mem_map's for valid memory
+ * 1) mem_sections - memory sections, mem_map's for valid memory
  */
 #ifdef CONFIG_SPARSEMEM_EXTREME
 struct mem_section **mem_sections;
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
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-rename-the-global-section-array-to-mem_sections.patch
mm-rename-the-global-section-array-to-mem_sections-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
mm-rmap-make-try_to_unmap-void-function-fix.patch
mm-rmap-make-try_to_unmap-void-function-fix-fix.patch
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

