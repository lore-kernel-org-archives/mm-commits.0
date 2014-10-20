From: akpm@linux-foundation.org
Subject: [to-be-updated]
 oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 20 Oct 2014 13:59:02 -0700
Message-ID: <54457796.IN+Br5FYAUSidOaP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaJTU7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 16:59:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes

WARNING: line over 80 characters
#104: FILE: mm/page_alloc.c:2289:
+	 * PM-freezer should be notified that there might be an OOM killer on its

total: 0 errors, 1 warnings, 80 lines checked

./patches/oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/oom.h~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes include/linux/oom.h
diff -puN kernel/power/process.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes kernel/power/process.c
diff -puN mm/oom_kill.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes mm/oom_kill.c
diff -puN mm/page_alloc.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -2286,10 +2286,10 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	}
 
 	/*
-	 * PM-freezer should be notified that there might be an OOM killer on its
-	 * way to kill and wake somebody up. This is too early and we might end
-	 * up not killing anything but false positives are acceptable.
-	 * See freeze_processes.
+	 * PM-freezer should be notified that there might be an OOM killer on
+	 * its way to kill and wake somebody up. This is too early and we might
+	 * end up not killing anything but false positives are acceptable. See
+	 * freeze_processes().
 	 */
 	note_oom_kill();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

