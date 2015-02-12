From: akpm@linux-foundation.org
Subject: [folded-merged] zram-rework-reset-and-destroy-path-fix.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 14:15:42 -0800
Message-ID: <54dd260e.lBoItvFAvklsdrlv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbBLWPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:15:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-rework-reset-and-destroy-path-fix
has been removed from the -mm tree.  Its filename was
     zram-rework-reset-and-destroy-path-fix.patch

This patch was dropped because it was folded into zram-rework-reset-and-destroy-path.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-rework-reset-and-destroy-path-fix

tweak comment

Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1119,8 +1119,10 @@ static void destroy_devices(unsigned int
 
 	for (i = 0; i < nr; i++) {
 		zram = &zram_devices[i];
-		/* remove sysfs first, so no one will perform disksize
-		 * store while we destroying devices */
+		/*
+		 * Remove sysfs first, so no one will perform a disksize
+		 * store while we destroy the devices
+		 */
 		sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
 				&zram_disk_attr_group);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
zram-rework-reset-and-destroy-path.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch
kernelh-remove-ancient-__function__-hack-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

