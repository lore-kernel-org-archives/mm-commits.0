From: akpm@linux-foundation.org
Subject: [merged] mm-fix-the-comment-in-zlc_setup.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:39:36 -0800
Message-ID: <5283e388.0SpJX1vUhE4P+uAa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3KMUjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wuzhy@linux.vnet.ibm.com

Subject: [merged] mm-fix-the-comment-in-zlc_setup.patch removed from -mm tree
To: wuzhy@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:36 -0800


The patch titled
     Subject: mm/page_alloc.c: fix comment in zlc_setup()
has been removed from the -mm tree.  Its filename was
     mm-fix-the-comment-in-zlc_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: fix comment in zlc_setup()

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-fix-the-comment-in-zlc_setup mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-the-comment-in-zlc_setup
+++ a/mm/page_alloc.c
@@ -1705,7 +1705,7 @@ bool zone_watermark_ok_safe(struct zone
  * comments in mmzone.h.  Reduces cache footprint of zonelist scans
  * that have to skip over a lot of full or unallowed zones.
  *
- * If the zonelist cache is present in the passed in zonelist, then
+ * If the zonelist cache is present in the passed zonelist, then
  * returns a pointer to the allowed node mask (either the current
  * tasks mems_allowed, or node_states[N_MEMORY].)
  *
_

Patches currently in -mm which might be from wuzhy@linux.vnet.ibm.com are

origin.patch
linux-next.patch

