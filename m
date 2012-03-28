From: akpm@linux-foundation.org
Subject: [folded] pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:32:44 -0700
Message-ID: <20120328213244.A8418A0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:43075 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2C1Vcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:32:52 -0400
Received: by wibhj13 with SMTP id hj13so81469wib.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:32:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.lezcano@free.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch

This patch was dropped because it was folded into pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#111: FILE: kernel/pid_namespace.c:233:
+	switch(cmd) {

total: 1 errors, 0 warnings, 95 lines checked

./patches/pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes
+++ a/kernel/pid_namespace.c
@@ -226,7 +226,7 @@ int reboot_pid_ns(struct pid_namespace *
 	if (pid_ns == &init_pid_ns)
 		return 0;
 
-	switch(cmd) {
+	switch (cmd) {
 	case LINUX_REBOOT_CMD_RESTART2:
 	case LINUX_REBOOT_CMD_RESTART:
 		pid_ns->reboot = SIGHUP;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
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

