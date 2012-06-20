From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 20 Jun 2012 12:25:42 -0700
Message-ID: <20120620192543.E14D3A016C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56208 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab2FTTZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 15:25:45 -0400
Received: by yenl3 with SMTP id l3so764214yen.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 12:25:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/sb_edac.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/edac/sb_edac.c~linux-next-git-rejects drivers/edac/sb_edac.c
--- a/drivers/edac/sb_edac.c~linux-next-git-rejects
+++ a/drivers/edac/sb_edac.c
@@ -1596,13 +1596,8 @@ static void sbridge_unregister_mci(struc
 
 	pvt = mci->pvt_info;
 
-<<<<<<< HEAD
-	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
-		__func__, mci, &sbridge_dev->pdev[0]->dev);
-=======
 	edac_dbg(0, "MC: mci = %p, dev = %p\n",
 		 mci, &sbridge_dev->pdev[0]->dev);
->>>>>>> linux-next/akpm-base
 
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->pdev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-power-power_supply_corec-partially-fix.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
memcg-prevent-from-oom-with-too-many-dirty-pages-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
backlight-l4f00242t03-use-devm_gpio_request_one-fix.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

