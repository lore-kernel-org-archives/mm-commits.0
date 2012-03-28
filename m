From: akpm@linux-foundation.org
Subject: [folded] move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:34:10 -0700
Message-ID: <20120328213410.B4098A0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59248 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab2C1VeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:34:12 -0400
Received: by eaaq10 with SMTP id q10so73346eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:34:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, dyoung@redhat.com, fengguang.wu@intel.com, fweisbec@gmail.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix
has been removed from the -mm tree.  Its filename was
     move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch

This patch was dropped because it was folded into move-hugepage-test-examples-to-tools-testing-selftests-vm.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix

Documentation/vm/ no longer has a Makefile. Fixes "make clean".

Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/Makefile~move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix Documentation/Makefile
--- a/Documentation/Makefile~move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix
+++ a/Documentation/Makefile
@@ -1,3 +1,3 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
 	filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
-	pcmcia/ spi/ timers/ vm/ watchdog/src/
+	pcmcia/ spi/ timers/ watchdog/src/
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

