From: akpm@linux-foundation.org
Subject: [folded] memstick-add-support-for-legacy-memorysticks-update.patch removed from -mm tree
Date: Tue, 15 Mar 2011 17:53:47 -0700
Message-ID: <201103160056.p2G0txUC022537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776Ab1CPA4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 20:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maximlevitsky@gmail.com, fujita.tomonori@lab.ntt.co.jp, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick-add-support-for-legacy-memorysticks-update
has been removed from the -mm tree.  Its filename was
     memstick-add-support-for-legacy-memorysticks-update.patch

This patch was dropped because it was folded into memstick-add-support-for-legacy-memorysticks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick-add-support-for-legacy-memorysticks-update
From: Maxim Levitsky <maximlevitsky@gmail.com>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/ms_block.c~memstick-add-support-for-legacy-memorysticks-update drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~memstick-add-support-for-legacy-memorysticks-update
+++ a/drivers/memstick/core/ms_block.c
@@ -1354,7 +1354,7 @@ static int msb_ftl_scan(struct msb_data 
 			continue;
 		}
 
-		ms_printk("collision between blocks %d and %d with"
+		ms_printk("collision between blocks %d and %d,"
 		" without stable flag set on both, erasing pba %d",
 				pba, other_block, other_block);
 
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
maintainers-update-media-path.patch
scatterlist-new-helper-functions.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch

