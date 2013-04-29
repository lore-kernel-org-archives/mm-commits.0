From: akpm@linux-foundation.org
Subject: [folded-merged] kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:45:07 -0700
Message-ID: <20130429214507.5D80B31C257@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52677 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818Ab3D2VpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:45:08 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so240446qab.5
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:45:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, kumagai-atsushi@mxc.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-vmalloc-export-additional-vmalloc-layer-information-fix
has been removed from the -mm tree.  Its filename was
     kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch

This patch was dropped because it was folded into kexec-vmalloc-export-additional-vmalloc-layer-information.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-vmalloc-export-additional-vmalloc-layer-information-fix

vmalloc.h should include list.h for list_head

Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/vmalloc.h~kexec-vmalloc-export-additional-vmalloc-layer-information-fix include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~kexec-vmalloc-export-additional-vmalloc-layer-information-fix
+++ a/include/linux/vmalloc.h
@@ -3,6 +3,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/list.h>
 #include <asm/page.h>		/* pgprot_t */
 #include <linux/rbtree.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

