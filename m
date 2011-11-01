From: akpm@linux-foundation.org
Subject: [merged] llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:49 -0700
Message-ID: <201111012116.pA1LGnSi016002@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, peterz@infradead.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: llist-return-whether-list-is-empty-before-adding-in-llist_add-fix
has been removed from the -mm tree.  Its filename was
     llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: llist-return-whether-list-is-empty-before-adding-in-llist_add-fix

clarify comment

Cc: Huang Ying <ying.huang@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/llist.h~llist-return-whether-list-is-empty-before-adding-in-llist_add-fix include/linux/llist.h
--- a/include/linux/llist.h~llist-return-whether-list-is-empty-before-adding-in-llist_add-fix
+++ a/include/linux/llist.h
@@ -148,7 +148,7 @@ static inline struct llist_node *llist_n
  * @new:	new entry to be added
  * @head:	the head for your lock-less list
  *
- * Return whether list is empty before adding.
+ * Returns true if the list was empty prior to adding this entry.
  */
 static inline bool llist_add(struct llist_node *new, struct llist_head *head)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
kexec-remove-kmsg_dump_kexec.patch
sysctl-add-support-for-poll-fix.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

