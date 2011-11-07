From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-vmw_balloonc-fix-typo-in-code-comment.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:53 -0800
Message-ID: <201111072029.pA7KTrIs006043@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1KGU34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, dtor@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/vmw_balloon.c: fix typo in code comment
has been removed from the -mm tree.  Its filename was
     drivers-misc-vmw_balloonc-fix-typo-in-code-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: drivers/misc/vmw_balloon.c: fix typo in code comment

Fix typo in code comment.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmw_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/vmw_balloon.c~drivers-misc-vmw_balloonc-fix-typo-in-code-comment drivers/misc/vmw_balloon.c
--- a/drivers/misc/vmw_balloon.c~drivers-misc-vmw_balloonc-fix-typo-in-code-comment
+++ a/drivers/misc/vmw_balloon.c
@@ -151,7 +151,7 @@ MODULE_LICENSE("GPL");
 struct vmballoon_stats {
 	unsigned int timer;
 
-	/* allocation statustics */
+	/* allocation statistics */
 	unsigned int alloc;
 	unsigned int alloc_fail;
 	unsigned int sleep_alloc;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch

