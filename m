From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-process_vm_accessc-mark-function-as-static-fix.patch removed from -mm
 tree
Date: Thu, 03 Apr 2014 14:07:00 -0700
Message-ID: <533dcd74.Z/71sE6UwKeSf5ts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaDCVHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rientjes@google.com, rashika.kheria@gmail.com, josh@joshtriplett.org, akpm@linux-foundation.org

Subject: [folded-merged] mm-process_vm_accessc-mark-function-as-static-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,josh@joshtriplett.org,rashika.kheria@gmail.com,rientjes@google.com,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:07:00 -0700


The patch titled
     Subject: mm-process_vm_accessc-mark-function-as-static-fix
has been removed from the -mm tree.  Its filename was
     mm-process_vm_accessc-mark-function-as-static-fix.patch

This patch was dropped because it was folded into mm-process_vm_accessc-mark-function-as-static.patch

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

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments-fix.patch
rtc-fixed-potential-race-condition-checkpatch-fixes.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

