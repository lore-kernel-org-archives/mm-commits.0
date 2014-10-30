From: akpm@linux-foundation.org
Subject: + kernel-add-panic_on_warn-checkpatch-fixes.patch added to -mm
 tree
Date: Thu, 30 Oct 2014 15:24:30 -0700
Message-ID: <5452ba9e.MuJOn/GSXtUEj//v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161292AbaJ3WY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 18:24:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, prarit@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-panic_on_warn-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kernel-add-panic_on_warn-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-panic_on_warn-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-panic_on_warn-checkpatch-fixes.patch

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
Subject: kernel-add-panic_on_warn-checkpatch-fixes

ERROR: spaces required around that '=' (ctx:VxV)
#188: FILE: include/uapi/linux/sysctl.h:156:
+	KERN_PANIC_ON_WARN=77, /* int: call panic() in WARN() functions */
 	                  ^

WARNING: unnecessary whitespace before a quoted newline
#222: FILE: kernel/panic.c:438:
+		panic("panic_on_warn set ... \n");

total: 1 errors, 1 warnings, 158 lines checked

./patches/kernel-add-panic_on_warn.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/panic.c~kernel-add-panic_on_warn-checkpatch-fixes kernel/panic.c
--- a/kernel/panic.c~kernel-add-panic_on_warn-checkpatch-fixes
+++ a/kernel/panic.c
@@ -435,7 +435,7 @@ static void warn_slowpath_common(const c
 		 * from panicking the system.
 		 */
 		panic_on_warn = 0;
-		panic("panic_on_warn set ... \n");
+		panic("panic_on_warn set ...\n");
 	}
 
 	print_modules();
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
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
kernel-add-panic_on_warn-checkpatch-fixes.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-vdso-vmac-fix-build-with-older-gcc.patch
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
a.patch

