Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE882C49EA6
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD152613B3
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhFXUIl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232120AbhFXUIl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 801B9613B1;
        Thu, 24 Jun 2021 20:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624565180;
        bh=8Kx54VDBHeCB8azQ9iL8m41+Zvs8hbYARcnOn1Lhz/U=;
        h=Date:From:To:Subject:From;
        b=0J4ZaAROdit0bk+2Feq55BNEDoPFh6+tFxK4Xw5z1oybEpHlRbGdhWqpN39nYuaRb
         UKbRVtpuJILLvQm4QTTkFEbQPYraHN5Q46ZcLY0lU0QpiNK+tKI34jVvzdr8ktMUoF
         iNoeJOw2zz2OVyOjpIJvSIsJsTbWSUgU7BvoultE=
Date:   Thu, 24 Jun 2021 13:06:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alexanderduyck@fb.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com,
        david@redhat.com, gshan@redhat.com, mm-commits@vger.kernel.org,
        mst@redhat.com, will@kernel.org
Subject:  [folded-merged]
 mm-page_reporting-export-reporting-order-as-module-parameter-fix.patch
 removed from -mm tree
Message-ID: <20210624200619.89KtvC3Te%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_reporting-export-reporting-order-as-module-parameter-fix
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-export-reporting-order-as-module-parameter-fix.patch

This patch was dropped because it was folded into mm-page_reporting-export-reporting-order-as-module-parameter.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_reporting-export-reporting-order-as-module-parameter-fix

mm/page_reporting.c needs module.h

Cc: Alexander Duyck <alexanderduyck@fb.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_reporting.c~mm-page_reporting-export-reporting-order-as-module-parameter-fix
+++ a/mm/page_reporting.c
@@ -4,6 +4,7 @@
 #include <linux/page_reporting.h>
 #include <linux/gfp.h>
 #include <linux/export.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-add-vmalloc_no_huge-fix.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
mm-page_reporting-export-reporting-order-as-module-parameter.patch
fs-remove-noop_set_page_dirty-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
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
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

