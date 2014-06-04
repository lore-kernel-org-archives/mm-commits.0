From: akpm@linux-foundation.org
Subject: [folded-merged]
 init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch removed from
 -mm tree
Date: Wed, 04 Jun 2014 15:54:37 -0700
Message-ID: <538fa3ad.QT1r3hJtZxCwnkMP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaFDWyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, rob@landley.net, richard.weinberger@gmail.com, prarit@redhat.com, peterz@infradead.org, mingo@kernel.org, jwboyer@fedoraproject.org, fweisbec@gmail.com, andi@firstfloor.org, akpm@linux-foundation.org

Subject: [folded-merged] init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,andi@firstfloor.org,fweisbec@gmail.com,jwboyer@fedoraproject.org,mingo@kernel.org,peterz@infradead.org,prarit@redhat.com,richard.weinberger@gmail.com,rob@landley.net,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:54:37 -0700


The patch titled
     Subject: init-mainc-add-initcall_blacklist-kernel-parameter-fix
has been removed from the -mm tree.  Its filename was
     init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch

This patch was dropped because it was folded into init-mainc-add-initcall_blacklist-kernel-parameter.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-mainc-add-initcall_blacklist-kernel-parameter-fix

tweak printk text

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-add-initcall_blacklist-kernel-parameter-fix init/main.c
--- a/init/main.c~init-mainc-add-initcall_blacklist-kernel-parameter-fix
+++ a/init/main.c
@@ -683,7 +683,7 @@ static int __init initcall_blacklist(cha
 	do {
 		str_entry = strsep(&str, ",");
 		if (str_entry) {
-			pr_debug("initcall blacklisted %s\n", str_entry);
+			pr_debug("blacklisting initcall %s\n", str_entry);
 			entry = alloc_bootmem(sizeof(*entry));
 			entry->buf = alloc_bootmem(strlen(str_entry) + 1);
 			strcpy(entry->buf, str_entry);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
swap-use-bdev_read_page-bdev_write_page.patch
mm-update-comment-for-default_max_map_count.patch
memcg-fold-mem_cgroup_stolen.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
mm-document-do_fault_around-feature.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
lib-btreec-fix-leak-of-whole-btree-nodes.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter.patch
init-mainc-remove-an-ifdef.patch

