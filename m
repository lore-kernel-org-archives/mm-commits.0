From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-add-0x-prefix-to-hex-block_size_bytes.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:03 -0800
Message-ID: <201001212128.o0LLS3Xd030690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325Ab0AUV2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, andi@firstfloor.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     memory-hotplug: add 0x prefix to HEX block_size_bytes
has been removed from the -mm tree.  Its filename was
     memory-hotplug-add-0x-prefix-to-hex-block_size_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory-hotplug: add 0x prefix to HEX block_size_bytes
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-add-0x-prefix-to-hex-block_size_bytes drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-0x-prefix-to-hex-block_size_bytes
+++ a/drivers/base/memory.c
@@ -311,7 +311,7 @@ static SYSDEV_ATTR(removable, 0444, show
 static ssize_t
 print_block_size(struct class *class, char *buf)
 {
-	return sprintf(buf, "%lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
+	return sprintf(buf, "%#lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
 }
 
 static CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch

