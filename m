From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 12 Mar 2013 12:07:10 -0700
Message-ID: <20130312190711.1C8C531C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:47190 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab3CLTHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 15:07:12 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so22109qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 12:07:11 -0700 (PDT)
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

 arch/tile/kernel/compat.c        |   12 ------------
 include/linux/regulator/driver.h |    3 ---
 2 files changed, 15 deletions(-)

diff -puN arch/tile/kernel/compat.c~linux-next-git-rejects arch/tile/kernel/compat.c
--- a/arch/tile/kernel/compat.c~linux-next-git-rejects
+++ a/arch/tile/kernel/compat.c
@@ -56,21 +56,9 @@ COMPAT_SYSCALL_DEFINE6(pwrite64, unsigne
 	return sys_pwrite64(fd, ubuf, count, ((loff_t)high << 32) | low);
 }
 
-<<<<<<< HEAD
-COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, low, u32, high,
-                       char __user *, buf, size_t, len)
-{
-	return sys_lookup_dcookie(((loff_t)high << 32) | low, buf, len);
-}
-
-COMPAT_SYSCALL_DEFINE6(sync_file_range2, int, fd, unsigned int, flags,
-                       u32, offset_lo, u32, offset_hi,
-                       u32, nbytes_lo, u32, nbytes_hi)
-=======
 long compat_sys_sync_file_range2(int fd, unsigned int flags,
 				 u32 offset_lo, u32 offset_hi,
 				 u32 nbytes_lo, u32 nbytes_hi)
->>>>>>> linux-next/akpm-base
 {
 	return sys_sync_file_range(fd, ((loff_t)offset_hi << 32) | offset_lo,
 				   ((loff_t)nbytes_hi << 32) | nbytes_lo,
diff -puN include/linux/regulator/driver.h~linux-next-git-rejects include/linux/regulator/driver.h
--- a/include/linux/regulator/driver.h~linux-next-git-rejects
+++ a/include/linux/regulator/driver.h
@@ -200,11 +200,8 @@ enum regulator_type {
  *                output when using regulator_set_voltage_sel_regmap
  * @enable_reg: Register for control when using regmap enable/disable ops
  * @enable_mask: Mask for control when using regmap enable/disable ops
-<<<<<<< HEAD
-=======
  * @enable_is_inverted: A flag to indicate set enable_mask bits to disable
  *                      when using regulator_enable_regmap and friends APIs.
->>>>>>> linux-next/akpm-base
  * @bypass_reg: Register for control when using regmap set_bypass
  * @bypass_mask: Mask for control when using regmap set_bypass
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
include-linux-res_counterh-needs-errnoh.patch
signal-always-clear-sa_restorer-on-execve-fix.patch
kernel-signalc-use-__arch_has_sa_restorer-instead-of-sa_restorer.patch
mm-fremapc-fix-oops-on-error-path.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
drivers-usb-dwc3-ep0c-fix-sparc64-build.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

