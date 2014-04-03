From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-groupsc-remove-return-value-of-set_groups-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:09:57 -0700
Message-ID: <533dce25.CVCKQKsKdVSVBNBR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbaDCVJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:09:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, udknight@gmail.com, serge.hallyn@canonical.com, eparis@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org

Subject: [folded-merged] kernel-groupsc-remove-return-value-of-set_groups-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,ebiederm@xmission.com,eparis@redhat.com,serge.hallyn@canonical.com,udknight@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:09:57 -0700


The patch titled
     Subject: kernel-groupsc-remove-return-value-of-set_groups-fix
has been removed from the -mm tree.  Its filename was
     kernel-groupsc-remove-return-value-of-set_groups-fix.patch

This patch was dropped because it was folded into kernel-groupsc-remove-return-value-of-set_groups.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-groupsc-remove-return-value-of-set_groups-fix

remove obsolete claims from set_groups() comment

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Wang YanQing <udknight@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/groups.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/groups.c~kernel-groupsc-remove-return-value-of-set_groups-fix kernel/groups.c
--- a/kernel/groups.c~kernel-groupsc-remove-return-value-of-set_groups-fix
+++ a/kernel/groups.c
@@ -157,9 +157,6 @@ int groups_search(const struct group_inf
  * set_groups - Change a group subscription in a set of credentials
  * @new: The newly prepared set of credentials to alter
  * @group_info: The group list to install
- *
- * Validate a group subscription and, if valid, insert it into a set
- * of credentials.
  */
 void set_groups(struct cred *new, struct group_info *group_info)
 {
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
kernel-groupsc-remove-return-value-of-set_groups.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments-fix.patch
rtc-fixed-potential-race-condition-checkpatch-fixes.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

