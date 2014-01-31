From: akpm@linux-foundation.org
Subject: [merged] zram-remove-old-private-project-comment.patch removed
 from -mm tree
Date: Fri, 31 Jan 2014 11:16:11 -0800
Message-ID: <52ebf67b.nz5a4ocARmoWllXN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbaAaTQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org

Subject: [merged] zram-remove-old-private-project-comment.patch removed from -mm tree
To: minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:11 -0800


The patch titled
     Subject: zram: remove old private project comment
has been removed from the -mm tree.  Its filename was
     zram-remove-old-private-project-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: remove old private project comment

Remove the old private compcache project address so upcoming patches
should be sent to LKML because we Linux kernel community will take care.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    6 ------
 drivers/block/zram/Kconfig      |    1 -
 drivers/block/zram/zram_drv.c   |    1 -
 drivers/block/zram/zram_drv.h   |    1 -
 4 files changed, 9 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-remove-old-private-project-comment Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-remove-old-private-project-comment
+++ a/Documentation/blockdev/zram.txt
@@ -1,8 +1,6 @@
 zram: Compressed RAM based block devices
 ----------------------------------------
 
-Project home: http://compcache.googlecode.com/
-
 * Introduction
 
 The zram module creates RAM based block devices named /dev/zram<id>
@@ -69,9 +67,5 @@ Following shows a typical sequence of st
 	resets the disksize to zero. You must set the disksize again
 	before reusing the device.
 
-Please report any problems at:
- - Mailing list: linux-mm-cc at laptop dot org
- - Issue tracker: http://code.google.com/p/compcache/issues/list
-
 Nitin Gupta
 ngupta@vflare.org
diff -puN drivers/block/zram/Kconfig~zram-remove-old-private-project-comment drivers/block/zram/Kconfig
--- a/drivers/block/zram/Kconfig~zram-remove-old-private-project-comment
+++ a/drivers/block/zram/Kconfig
@@ -14,7 +14,6 @@ config ZRAM
 	  disks and maybe many more.
 
 	  See zram.txt for more information.
-	  Project home: <https://compcache.googlecode.com/>
 
 config ZRAM_DEBUG
 	bool "Compressed RAM block device debug support"
diff -puN drivers/block/zram/zram_drv.c~zram-remove-old-private-project-comment drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-old-private-project-comment
+++ a/drivers/block/zram/zram_drv.c
@@ -9,7 +9,6 @@
  * Released under the terms of 3-clause BSD License
  * Released under the terms of GNU General Public License Version 2.0
  *
- * Project home: http://compcache.googlecode.com
  */
 
 #define KMSG_COMPONENT "zram"
diff -puN drivers/block/zram/zram_drv.h~zram-remove-old-private-project-comment drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-old-private-project-comment
+++ a/drivers/block/zram/zram_drv.h
@@ -9,7 +9,6 @@
  * Released under the terms of 3-clause BSD License
  * Released under the terms of GNU General Public License Version 2.0
  *
- * Project home: http://compcache.googlecode.com
  */
 
 #ifndef _ZRAM_DRV_H_
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
debugging-keep-track-of-page-owners.patch

