From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 28 Oct 2014 13:50:53 -0700
Message-ID: <545001ad.MZAntefzTQ7BueGf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaJ1Uuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 16:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes

WARNING: 'retuned' may be misspelled - perhaps 'returned'?
#112: FILE: fs/ocfs2/file.c:2329:
+		 * If generic_file_buffered_write() retuned a synchronous error

total: 0 errors, 1 warnings, 121 lines checked

./patches/ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes
+++ a/fs/ocfs2/file.c
@@ -2326,7 +2326,7 @@ relock:
 		count -= written;
 		written_buffered = generic_perform_write(file, from, *ppos);
 		/*
-		 * If generic_file_buffered_write() retuned a synchronous error
+		 * If generic_file_buffered_write() returned a synchronous error
 		 * then we want to return the number of bytes which were
 		 * direct-written, or the error code if that was zero.  Note
 		 * that this differs from normal direct-io semantics, which
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
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

