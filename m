From: akpm@linux-foundation.org
Subject: [folded-merged] sys_sysfs-add-config_sysfs_syscall-fix.patch
 removed from -mm tree
Date: Thu, 03 Apr 2014 14:09:22 -0700
Message-ID: <533dce02.F13ZyExgyXoZ2W5n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaDCVJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be, akpm@linux-foundation.org

Subject: [folded-merged] sys_sysfs-add-config_sysfs_syscall-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:09:22 -0700


The patch titled
     Subject: sys_sysfs-add-config_sysfs_syscall-fix
has been removed from the -mm tree.  Its filename was
     sys_sysfs-add-config_sysfs_syscall-fix.patch

This patch was dropped because it was folded into sys_sysfs-add-config_sysfs_syscall.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sys_sysfs-add-config_sysfs_syscall-fix

tweak Kconfig help text

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/Kconfig~sys_sysfs-add-config_sysfs_syscall-fix init/Kconfig
--- a/init/Kconfig~sys_sysfs-add-config_sysfs_syscall-fix
+++ a/init/Kconfig
@@ -1294,9 +1294,9 @@ config SYSFS_SYSCALL
 	bool "Sysfs syscall support" if EXPERT
 	default y
 	---help---
-	  sys_sysfs is an obsolete system call no longer supported in
-	  libc.Note that disabling this option while being more secure breaks
-	  compatibility with other systems.
+	  sys_sysfs is an obsolete system call no longer supported in libc.
+	  Note that disabling this option is more secure but might break
+	  compatibility with some systems.
 
 	  If unsure say Y here.
 
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
sys_sysfs-add-config_sysfs_syscall.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments-fix.patch
rtc-fixed-potential-race-condition-checkpatch-fixes.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

