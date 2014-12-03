From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch added to
 -mm tree
Date: Wed, 03 Dec 2014 15:28:30 -0800
Message-ID: <547f9c9e.x+AZIhA8ULavTPEB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLCX2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 18:28:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, michele.curti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix

clean up layout

Cc: Michele Curti <michele.curti@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix
+++ a/mm/memcontrol.c
@@ -1615,6 +1615,7 @@ static void mem_cgroup_out_of_memory(str
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
 }
+
 #if MAX_NUMNODES > 1
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
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
sparc-add-pmd_-for-thp-fix.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
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
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

