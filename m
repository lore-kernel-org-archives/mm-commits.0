From: akpm@linux-foundation.org
Subject: + zram-restrict-add-remove-attributes-to-root-only-fix.patch
 added to -mm tree
Date: Wed, 07 Dec 2016 14:21:39 -0800
Message-ID: <58488b73.1vdcMEEwJJM6eUh+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60666 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932339AbcLGWVS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2016 17:21:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, steven@stebalien.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-restrict-add-remove-attributes-to-root-only-fix
has been added to the -mm tree.  Its filename is
     zram-restrict-add-remove-attributes-to-root-only-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-restrict-add-remove-attributes-to-root-only-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-restrict-add-remove-attributes-to-root-only-fix.patch

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
Subject: zram-restrict-add-remove-attributes-to-root-only-fix

s/sence/sense/, reflow comment to use 80 cols

Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Allen <steven@stebalien.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-restrict-add-remove-attributes-to-root-only-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-restrict-add-remove-attributes-to-root-only-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1414,11 +1414,10 @@ static ssize_t hot_remove_store(struct c
 }
 
 /*
- * NOTE: hot_add attribute is not the usual read-only sysfs
- * attribute. In a sence that reading from this file does alter
- * the state of your system -- it creates a new un-initialized
- * zram device and returns back this device's device_id (or an
- * error code if it fails to create a new device).
+ * NOTE: hot_add attribute is not the usual read-only sysfs attribute. In a
+ * sense that reading from this file does alter the state of your system -- it
+ * creates a new un-initialized zram device and returns back this device's
+ * device_id (or an error code if it fails to create a new device).
  */
 static struct class_attribute zram_control_class_attrs[] = {
 	__ATTR(hot_add, 0400, hot_add_show, NULL),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zram-restrict-add-remove-attributes-to-root-only-fix.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
drivers-clk-uniphier-clk-uniphierh-fix-build-with-old-gcc.patch
drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

