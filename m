From: akpm@linux-foundation.org
Subject: [obsolete] memcg-change-behavior-of-moving-charges-at-task-move-fix.patch removed from -mm tree
Date: Mon, 26 Mar 2012 16:46:50 -0700
Message-ID: <20120326234651.1FCABA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61680 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab2CZXqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 19:46:52 -0400
Received: by qabg24 with SMTP id g24so364690qab.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 16:46:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-change-behavior-of-moving-charges-at-task-move-fix
has been removed from the -mm tree.  Its filename was
     memcg-change-behavior-of-moving-charges-at-task-move-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-change-behavior-of-moving-charges-at-task-move-fix

Cc: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-change-behavior-of-moving-charges-at-task-move-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-behavior-of-moving-charges-at-task-move-fix
+++ a/mm/memcontrol.c
@@ -5137,7 +5137,8 @@ static struct page *mc_handle_swap_pte(s
 		return NULL;
 #ifdef CONFIG_SWAP
 	/*
-	 * Avoid lookup_swap_cache() not to update statistics.
+	 * Use find_get_page() rather than lookup_swap_cache() because the
+	 * latter alters statistics.
 	 */
 	page = find_get_page(&swapper_space, ent.val);
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
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

