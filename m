From: akpm@linux-foundation.org
Subject: + mm-process_vm_accessc-mark-function-as-static-fix.patch added
 to -mm tree
Date: Mon, 24 Feb 2014 12:53:49 -0800
Message-ID: <530bb15d.XhS1QklquBMAJN5z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaBXUxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 15:53:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rientjes@google.com, rashika.kheria@gmail.com, josh@joshtriplett.org, akpm@linux-foundation.org

Subject: + mm-process_vm_accessc-mark-function-as-static-fix.patch added to -mm tree
To: akpm@linux-foundation.org,josh@joshtriplett.org,rashika.kheria@gmail.com,rientjes@google.com,sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 12:53:49 -0800


The patch titled
     Subject: mm-process_vm_accessc-mark-function-as-static-fix
has been added to the -mm tree.  Its filename is
     mm-process_vm_accessc-mark-function-as-static-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-process_vm_accessc-mark-function-as-static-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-process_vm_accessc-mark-function-as-static-fix.patch

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
Subject: mm-process_vm_accessc-mark-function-as-static-fix

remove unneeded asmlinkage - compat_process_vm_rw isn't referenced from asm

Cc: David Rientjes <rientjes@google.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/process_vm_access.c~mm-process_vm_accessc-mark-function-as-static-fix mm/process_vm_access.c
--- a/mm/process_vm_access.c~mm-process_vm_accessc-mark-function-as-static-fix
+++ a/mm/process_vm_access.c
@@ -412,7 +412,7 @@ SYSCALL_DEFINE6(process_vm_writev, pid_t
 
 #ifdef CONFIG_COMPAT
 
-static asmlinkage ssize_t
+static ssize_t
 compat_process_vm_rw(compat_pid_t pid,
 		     const struct compat_iovec __user *lvec,
 		     unsigned long liovcnt,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

