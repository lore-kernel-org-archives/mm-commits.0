From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 01 Dec 2014 13:03:48 -0800
Message-ID: <547cd7b4.GGZ54PGCCUmt79Wx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaLAVDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 16:03:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsd.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/nfsd/nfsd.h~linux-next-git-rejects fs/nfsd/nfsd.h
--- a/fs/nfsd/nfsd.h~linux-next-git-rejects
+++ a/fs/nfsd/nfsd.h
@@ -342,11 +342,7 @@ void		nfsd_lockd_shutdown(void);
 
 #define NFSD4_2_SUPPORTED_ATTRS_WORD2 \
 	(NFSD4_1_SUPPORTED_ATTRS_WORD2 | \
-<<<<<<< HEAD
-	NFSD4_2_SECURITY_ATTRS)
-=======
 	FATTR4_WORD2_CHANGE_ATTR_TYPE | NFSD4_2_SECURITY_ATTRS)
->>>>>>> linux-next/akpm-base
 
 static inline u32 nfsd_suppattrs0(u32 minorversion)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmpressurec-fix-race-in-vmpressure_work_fn.patch
mm-vmpressurec-fix-race-in-vmpressure_work_fn-fix.patch
drivers-input-evdevc-dont-kfree-a-vmalloc-address.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch
include-linux-kmemleakh-needs-slabh.patch
x86-add-pmd_-for-thp-fix.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-media-makefile-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

