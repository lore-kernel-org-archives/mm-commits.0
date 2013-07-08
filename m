From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-comment-referring-to-non-existent-size_seqlock-change-to-span_seqlock.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:06 -0700
Message-ID: <51db1212.AuTY6Chk9z7IlqoU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3GHTZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-fix-comment-referring-to-non-existent-size_seqlock-change-to-span_seqlock.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:06 -0700


The patch titled
     Subject: mm: fix comment referring to non-existent size_seqlock, change to span_seqlock
has been removed from the -mm tree.  Its filename was
     mm-fix-comment-referring-to-non-existent-size_seqlock-change-to-span_seqlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm: fix comment referring to non-existent size_seqlock, change to span_seqlock

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-fix-comment-referring-to-non-existent-size_seqlock-change-to-span_seqlock include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-comment-referring-to-non-existent-size_seqlock-change-to-span_seqlock
+++ a/include/linux/mmzone.h
@@ -733,7 +733,7 @@ typedef struct pglist_data {
 	 * or node_spanned_pages stay constant.  Holding this will also
 	 * guarantee that any pfn_valid() stays that way.
 	 *
-	 * Nests above zone->lock and zone->size_seqlock.
+	 * Nests above zone->lock and zone->span_seqlock
 	 */
 	spinlock_t node_size_lock;
 #endif
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

