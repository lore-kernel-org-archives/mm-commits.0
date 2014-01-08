From: akpm@linux-foundation.org
Subject: + zram-remove-old-private-project-comment.patch added to -mm tree
Date: Wed, 08 Jan 2014 15:22:30 -0800
Message-ID: <52cdddb6.7XVCKkdppmtJOEvz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaAHXWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 18:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org

Subject: + zram-remove-old-private-project-comment.patch added to -mm tree
To: minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 15:22:30 -0800


The patch titled
     Subject: zram: remove old private project comment
has been added to the -mm tree.  Its filename is
     zram-remove-old-private-project-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-old-private-project-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-old-private-project-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-bug_on-from-mlock_vma_page.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-zswapc-change-params-from-hidden-to-ro.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch
zram-remove-old-private-project-comment.patch
zram-add-copyright.patch
zsmalloc-add-copyright.patch
zram-add-zram-maintainers.patch
zsmalloc-add-maintainers.patch
debugging-keep-track-of-page-owners.patch

