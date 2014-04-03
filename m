From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch removed from -mm
 tree
Date: Thu, 03 Apr 2014 14:02:49 -0700
Message-ID: <533dcc79.iRwSCCAsMc1jh/oV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaDCVCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: [folded-merged] ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:02:49 -0700


The patch titled
     Subject: ocfs2-add-dlm_recover_callback_support-in-sysfs-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch

This patch was dropped because it was folded into ocfs2-add-dlm_recover_callback_support-in-sysfs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-add-dlm_recover_callback_support-in-sysfs-fix

simplify

Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-add-dlm_recover_callback_support-in-sysfs-fix fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-add-dlm_recover_callback_support-in-sysfs-fix
+++ a/fs/ocfs2/stackglue.c
@@ -607,9 +607,7 @@ static ssize_t ocfs2_dlm_recover_show(st
 					struct kobj_attribute *attr,
 					char *buf)
 {
-	ssize_t ret;
-	ret = snprintf(buf, PAGE_SIZE, "1\n");
-	return ret;
+	return snprintf(buf, PAGE_SIZE, "1\n");
 }
 
 static struct kobj_attribute ocfs2_attr_dlm_recover_support =
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
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

