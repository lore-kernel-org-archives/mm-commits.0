From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:09:08 -0700
Message-ID: <533dcdf4.u5ZMtrk2qI3ACITZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaDCVJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rashika.kheria@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,rashika.kheria@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:09:08 -0700


The patch titled
     Subject: include-linux-syscallsh-add-sys32_quotactl-prototype-fix
has been removed from the -mm tree.  Its filename was
     include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch

This patch was dropped because it was folded into include-linux-syscallsh-add-sys32_quotactl-prototype.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-linux-syscallsh-add-sys32_quotactl-prototype-fix

Cc: Rashika Kheria <rashika.kheria@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype-fix include/linux/syscalls.h
--- a/include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype-fix
+++ a/include/linux/syscalls.h
@@ -198,11 +198,8 @@ extern struct trace_event_functions exit
 	}								\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
-#ifdef CONFIG_QUOTACTL_COMPAT
 asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
 			       qid_t id, void __user *addr);
-#endif
-
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
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
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
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

