From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix.patch removed
 from -mm tree
Date: Wed, 31 May 2017 14:01:24 -0700
Message-ID: <592f2f24.JgRR2riYuzGs3bFj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdEaVBZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 17:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbacik@fb.com, josef@toxicpanda.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix
has been removed from the -mm tree.  Its filename was
     mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix

fix comment

Cc: Josef Bacik <jbacik@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix
+++ a/mm/vmscan.c
@@ -2598,9 +2598,9 @@ static bool shrink_node(pg_data_t *pgdat
 
 	/*
 	 * We still want to slightly prefer slab over inactive, so if the
-	 * inactive on this node is large enough and what is pushing us into
-	 * reclaim terretitory then limit our flushing to the inactive list for
-	 * the first go around.
+	 * inactive on this node is large enough and is pushing us into reclaim
+	 * terrtitory then limit our flushing to the inactive list for the first
+	 * go around.
 	 *
 	 * The idea is that with a memcg configured system we will still reclaim
 	 * memcg aware shrinkers, which includes the super block shrinkers.  So
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

