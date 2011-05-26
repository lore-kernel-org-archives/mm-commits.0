From: akpm@linux-foundation.org
Subject: [folded] fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:19:09 -0700
Message-ID: <201105262319.p4QNJAwp026478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EZXTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:19:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Matt_Domsch@dell.com, davej@codemonkey.org.uk, eugeneteo@kernel.sg, warns@pre-sense.de, mm-commits@vger.kernel.org


The patch titled
     fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix
has been removed from the -mm tree.  Its filename was
     fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch

This patch was dropped because it was folded into fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix layout and indenting

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Timo Warns <warns@pre-sense.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/efi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/partitions/efi.c~fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix fs/partitions/efi.c
--- a/fs/partitions/efi.c~fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix
+++ a/fs/partitions/efi.c
@@ -311,11 +311,11 @@ static int is_gpt_valid(struct parsed_pa
 	}
 
 	/* Check the GUID Partition Table header size */
-	if (le32_to_cpu((*gpt)->header_size) > bdev_logical_block_size(state->bdev)) {
-		pr_debug("GUID Partition Table Header size is wrong:"
-			 "%u > %u\n",
-             le32_to_cpu((*gpt)->header_size),
-             bdev_logical_block_size(state->bdev));
+	if (le32_to_cpu((*gpt)->header_size) >
+			bdev_logical_block_size(state->bdev)) {
+		pr_debug("GUID Partition Table Header size is wrong: %u > %u\n",
+			le32_to_cpu((*gpt)->header_size),
+			bdev_logical_block_size(state->bdev));
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
include-linux-hugetlbh-needs-mm_typesh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch
ufs-truncated-values-handling-64-bit-metadata.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
add-the-pagefault-count-into-memcg-stats.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

