From: akpm@linux-foundation.org
Subject: [withdrawn]
 slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 10 Nov 2014 14:16:07 -0800
Message-ID: <54613927.xenZ4m93H+4pOO+M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaKJWQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, treding@nvidia.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes

WARNING: Missing a blank line after declarations
#39: FILE: mm/slab.c:2981:
+		int max = shared_array->limit - shared_array->avail;
+		if (max) {

total: 0 errors, 1 warnings, 218 lines checked

./patches/slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Thierry Reding <treding@nvidia.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slab.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes mm/slab.c
--- a/mm/slab.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes
+++ a/mm/slab.c
@@ -2978,6 +2978,7 @@ static void cache_flusharray(struct kmem
 	if (n->shared) {
 		struct array_cache *shared_array = n->shared;
 		int max = shared_array->limit - shared_array->avail;
+
 		if (max) {
 			if (batchcount > max)
 				batchcount = max;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-ignore-marks-not-respected-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

