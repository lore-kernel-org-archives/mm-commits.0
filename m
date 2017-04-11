From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 11 Apr 2017 12:18:33 -0700
Message-ID: <58ed2c09.J3/sA2BsIAJeN+bv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60070 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752612AbdDKTSe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2017 15:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/caam/ctrl.c   |    6 ------
 drivers/crypto/caam/intern.h |    3 ---
 2 files changed, 9 deletions(-)

diff -puN arch/metag/include/asm/uaccess.h~linux-next-git-rejects arch/metag/include/asm/uaccess.h
diff -puN arch/metag/lib/usercopy.c~linux-next-git-rejects arch/metag/lib/usercopy.c
diff -puN drivers/crypto/caam/ctrl.c~linux-next-git-rejects drivers/crypto/caam/ctrl.c
--- a/drivers/crypto/caam/ctrl.c~linux-next-git-rejects
+++ a/drivers/crypto/caam/ctrl.c
@@ -313,14 +313,11 @@ static int caam_remove(struct platform_d
 
 	/* Remove platform devices under the crypto node */
 	of_platform_depopulate(ctrldev);
-<<<<<<< HEAD
-=======
 
 #ifdef CONFIG_CAAM_QI
 	if (ctrlpriv->qidev)
 		caam_qi_shutdown(ctrlpriv->qidev);
 #endif
->>>>>>> linux-next/akpm-base
 
 	/* De-initialize RNG state handles initialized by this driver. */
 	if (ctrlpriv->rng4_sh_init)
@@ -618,8 +615,6 @@ static int caam_probe(struct platform_de
 		dev_err(dev, "JR platform devices creation error\n");
 		goto iounmap_ctrl;
 	}
-<<<<<<< HEAD
-=======
 
 #ifdef CONFIG_DEBUG_FS
 	/*
@@ -632,7 +627,6 @@ static int caam_probe(struct platform_de
 	ctrlpriv->dfs_root = debugfs_create_dir(dev_name(dev), NULL);
 	ctrlpriv->ctl = debugfs_create_dir("ctl", ctrlpriv->dfs_root);
 #endif
->>>>>>> linux-next/akpm-base
 
 	ring = 0;
 	for_each_available_child_of_node(nprop, np)
diff -puN drivers/crypto/caam/intern.h~linux-next-git-rejects drivers/crypto/caam/intern.h
--- a/drivers/crypto/caam/intern.h~linux-next-git-rejects
+++ a/drivers/crypto/caam/intern.h
@@ -66,12 +66,9 @@ struct caam_drv_private_jr {
 struct caam_drv_private {
 
 	struct device *dev;
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_CAAM_QI
 	struct device *qidev;
 #endif
->>>>>>> linux-next/akpm-base
 	struct platform_device *pdev;
 
 	/* Physical-presence section */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

