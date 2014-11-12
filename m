From: akpm@linux-foundation.org
Subject: +
 tools-testing-selftests-makefile-alphasort-the-targets-list.patch added to
 -mm tree
Date: Wed, 12 Nov 2014 14:12:27 -0800
Message-ID: <5463db4b.PMG/B4nYp3n4tewM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaKLWM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:12:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/Makefile: alphasort the TARGETS list
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-makefile-alphasort-the-targets-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-testing-selftests-makefile-alphasort-the-targets-list.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-selftests-makefile-alphasort-the-targets-list.patch

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
Subject: tools/testing/selftests/Makefile: alphasort the TARGETS list

This list is supposed to be sorted, to reduce patch collisions.

Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN tools/testing/selftests/Makefile~tools-testing-selftests-makefile-alphasort-the-targets-list tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~tools-testing-selftests-makefile-alphasort-the-targets-list
+++ a/tools/testing/selftests/Makefile
@@ -2,20 +2,21 @@ TARGETS = breakpoints
 TARGETS += cpu-hotplug
 TARGETS += efivarfs
 TARGETS += exec
+TARGETS += firmware
+TARGETS += ftrace
 TARGETS += kcmp
 TARGETS += memfd
 TARGETS += memory-hotplug
 TARGETS += mqueue
 TARGETS += mount
 TARGETS += net
+TARGETS += powerpc
 TARGETS += ptrace
+TARGETS += sysctl
 TARGETS += timers
-TARGETS += vm
-TARGETS += powerpc
 TARGETS += user
-TARGETS += sysctl
-TARGETS += firmware
-TARGETS += ftrace
+TARGETS += vm
+#Please keep the TARGETS list alphabetically sorted
 
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
syscallsx86-implement-execveat-system-call-fix.patch
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
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

