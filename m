From: akpm@linux-foundation.org
Subject: [merged] mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:59 -0700
Message-ID: <201111012110.pA1LAxJm011675@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15793 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1KAVLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix
has been removed from the -mm tree.  Its filename was
     mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix

fiddle wording

Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/backing-dev.c~mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix mm/backing-dev.c
--- a/mm/backing-dev.c~mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix
+++ a/mm/backing-dev.c
@@ -404,9 +404,8 @@ static int bdi_forker_thread(void *ptr)
 		/*
 		 * In the following loop we are going to check whether we have
 		 * some work to do without any synchronization with tasks
-		 * waking us up to do work for them. So we have to set task
-		 * state already here so that we don't miss wakeups coming
-		 * after we verify some condition.
+		 * waking us up to do work for them. Set the task state here
+		 * so that we don't miss wakeups after verifying conditions.
 		 */
 		set_current_state(TASK_INTERRUPTIBLE);
 
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

