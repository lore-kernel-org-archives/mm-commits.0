From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 19 Mar 2014 14:05:33 -0700
Message-ID: <532a069d.Gojj5GyVn07zIOa3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaCSVFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 17:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xuejiufei@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jiangyiwen@huawei.com, akpm@linux-foundation.org

Subject: [folded-merged] ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,jiangyiwen@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,xuejiufei@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 14:05:33 -0700


The patch titled
     Subject: ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch

This patch was dropped because it was folded into ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes

ERROR: code indent should use tabs where possible
#56: FILE: fs/ocfs2/dlm/dlmmaster.c:3087:
+                       if (tmp->type == DLM_MLE_MASTER) {$

WARNING: please, no spaces at the start of a line
#56: FILE: fs/ocfs2/dlm/dlmmaster.c:3087:
+                       if (tmp->type == DLM_MLE_MASTER) {$

WARNING: suspect code indent for conditional statements (23, 31)
#56: FILE: fs/ocfs2/dlm/dlmmaster.c:3087:
+                       if (tmp->type == DLM_MLE_MASTER) {
+                               ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;

ERROR: code indent should use tabs where possible
#57: FILE: fs/ocfs2/dlm/dlmmaster.c:3088:
+                               ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;$

WARNING: please, no spaces at the start of a line
#57: FILE: fs/ocfs2/dlm/dlmmaster.c:3088:
+                               ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;$

ERROR: code indent should use tabs where possible
#58: FILE: fs/ocfs2/dlm/dlmmaster.c:3089:
+                               mlog(0, "%s:%.*s: master=%u, newmaster=%u, "$

WARNING: please, no spaces at the start of a line
#58: FILE: fs/ocfs2/dlm/dlmmaster.c:3089:
+                               mlog(0, "%s:%.*s: master=%u, newmaster=%u, "$

WARNING: quoted string split across lines
#59: FILE: fs/ocfs2/dlm/dlmmaster.c:3090:
+                               mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
+                                               "telling master to get ref "

ERROR: code indent should use tabs where possible
#59: FILE: fs/ocfs2/dlm/dlmmaster.c:3090:
+                                               "telling master to get ref "$

WARNING: please, no spaces at the start of a line
#59: FILE: fs/ocfs2/dlm/dlmmaster.c:3090:
+                                               "telling master to get ref "$

WARNING: quoted string split across lines
#60: FILE: fs/ocfs2/dlm/dlmmaster.c:3091:
+                                               "telling master to get ref "
+                                               "for cleared out mle during "

ERROR: code indent should use tabs where possible
#60: FILE: fs/ocfs2/dlm/dlmmaster.c:3091:
+                                               "for cleared out mle during "$

WARNING: please, no spaces at the start of a line
#60: FILE: fs/ocfs2/dlm/dlmmaster.c:3091:
+                                               "for cleared out mle during "$

WARNING: quoted string split across lines
#61: FILE: fs/ocfs2/dlm/dlmmaster.c:3092:
+                                               "for cleared out mle during "
+                                               "migration\n", dlm->name,

ERROR: code indent should use tabs where possible
#61: FILE: fs/ocfs2/dlm/dlmmaster.c:3092:
+                                               "migration\n", dlm->name,$

WARNING: please, no spaces at the start of a line
#61: FILE: fs/ocfs2/dlm/dlmmaster.c:3092:
+                                               "migration\n", dlm->name,$

ERROR: code indent should use tabs where possible
#62: FILE: fs/ocfs2/dlm/dlmmaster.c:3093:
+                                               namelen, name, master,$

WARNING: please, no spaces at the start of a line
#62: FILE: fs/ocfs2/dlm/dlmmaster.c:3093:
+                                               namelen, name, master,$

ERROR: code indent should use tabs where possible
#63: FILE: fs/ocfs2/dlm/dlmmaster.c:3094:
+                                               new_master);$

WARNING: please, no spaces at the start of a line
#63: FILE: fs/ocfs2/dlm/dlmmaster.c:3094:
+                                               new_master);$

ERROR: code indent should use tabs where possible
#64: FILE: fs/ocfs2/dlm/dlmmaster.c:3095:
+                       }$

WARNING: please, no spaces at the start of a line
#64: FILE: fs/ocfs2/dlm/dlmmaster.c:3095:
+                       }$

total: 9 errors, 13 warnings, 20 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Xue jiufei <xuejiufei@huawei.com>
Cc: jiangyiwen <jiangyiwen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -3084,15 +3084,15 @@ static int dlm_add_migration_mle(struct
 			/* remove it so that only one mle will be found */
 			__dlm_unlink_mle(dlm, tmp);
 			__dlm_mle_detach_hb_events(dlm, tmp);
-                       if (tmp->type == DLM_MLE_MASTER) {
-                               ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
-                               mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
-                                               "telling master to get ref "
-                                               "for cleared out mle during "
-                                               "migration\n", dlm->name,
-                                               namelen, name, master,
-                                               new_master);
-                       }
+			if (tmp->type == DLM_MLE_MASTER) {
+				ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
+				mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
+						"telling master to get ref "
+						"for cleared out mle during "
+						"migration\n", dlm->name,
+						namelen, name, master,
+						new_master);
+			}
 		}
 		spin_unlock(&tmp->spinlock);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
fs-inodec-inode_lru_isolate-use-atomic-count_vm_events.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
befs-logging-clean-up-fix.patch
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
drivers-gpio-gpio-zevioc-fix-build.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

