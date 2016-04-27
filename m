From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-kasan-initial-memory-quarantine-implementation-v8-fix.patch removed from -mm tree
Date: Wed, 27 Apr 2016 13:37:42 -0700
Message-ID: <57212316.OiKnfBXDgBl2aYfl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbcD0Uhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 16:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kasan-initial-memory-quarantine-implementation-v8-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-initial-memory-quarantine-implementation-v8-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kasan-initial-memory-quarantine-implementation-v8-fix

fix CONFIG_DEBUG_VM=n build

Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-kasan-initial-memory-quarantine-implementation-v8-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-kasan-initial-memory-quarantine-implementation-v8-fix
+++ a/mm/page_alloc.c
@@ -1053,7 +1053,7 @@ static bool free_pcp_prepare(struct page
 
 	trace_mm_page_free(page, 0);
 	kmemcheck_free_shadow(page, 0);
-	kasan_free_pages(page, 0);
+	kasan_poison_free_pages(page, 0);
 
 	if (PageAnonHead(page))
 		page->mapping = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

