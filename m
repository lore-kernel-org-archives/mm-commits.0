From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 14 Apr 2014 13:07:15 -0700
Message-ID: <534c3ff3.Eyh5mKBBuCVUs7Zp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaDNUHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Apr 2014 16:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 14 Apr 2014 13:07:15 -0700


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

 drivers/platform/x86/alienware-wmi.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff -puN arch/powerpc/Makefile~linux-next-git-rejects arch/powerpc/Makefile
diff -puN drivers/platform/x86/alienware-wmi.c~linux-next-git-rejects drivers/platform/x86/alienware-wmi.c
--- a/drivers/platform/x86/alienware-wmi.c~linux-next-git-rejects
+++ a/drivers/platform/x86/alienware-wmi.c
@@ -368,29 +368,12 @@ static int alienware_zone_init(struct pl
 	zone_dev_attrs =
 	    kzalloc(sizeof(struct device_attribute) * (quirks->num_zones + 1),
 		    GFP_KERNEL);
-<<<<<<< HEAD
-	if (!zone_dev_attrs)
-		return -ENOMEM;
-
 	zone_attrs =
 	    kzalloc(sizeof(struct attribute *) * (quirks->num_zones + 2),
 		    GFP_KERNEL);
-	if (!zone_attrs)
-		return -ENOMEM;
-
 	zone_data =
 	    kzalloc(sizeof(struct platform_zone) * (quirks->num_zones),
 		    GFP_KERNEL);
-	if (!zone_data)
-		return -ENOMEM;
-=======
-	zone_attrs =
-	    kzalloc(sizeof(struct attribute *) * (quirks->num_zones + 2),
-		    GFP_KERNEL);
-	zone_data =
-	    kzalloc(sizeof(struct platform_zone) * (quirks->num_zones),
-		    GFP_KERNEL);
->>>>>>> linux-next/akpm-base
 
 	for (i = 0; i < quirks->num_zones; i++) {
 		sprintf(buffer, "zone%02X", i);
@@ -563,15 +546,9 @@ module_init(alienware_wmi_init);
 
 static void __exit alienware_wmi_exit(void)
 {
-<<<<<<< HEAD
-	if (platform_device) {
-		alienware_zone_exit(platform_device);
-		remove_hdmi(platform_device);
-=======
 	alienware_zone_exit(platform_device);
 	remove_hdmi(platform_device);
 	if (platform_device) {
->>>>>>> linux-next/akpm-base
 		platform_device_unregister(platform_device);
 		platform_driver_unregister(&platform_driver);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

