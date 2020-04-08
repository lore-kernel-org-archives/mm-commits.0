From: akpm@linux-foundation.org
Subject: [merged]
 lib-scatterlist-fix-sg_copy_buffer-kerneldoc.patch removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:00 -0700
Message-ID: <20200408020100.lRcN0S8ZP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgDHCBA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: fix sg_copy_buffer() kerneldoc
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-fix-sg_copy_buffer-kerneldoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib/scatterlist: fix sg_copy_buffer() kerneldoc

Add the missing closing parenthesis to the description for the to_buffer
parameter of sg_copy_buffer().

Link: http://lkml.kernel.org/r/20200212084241.8778-1-geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Akinobu Mita <akinobu.mita@gmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/scatterlist.c~lib-scatterlist-fix-sg_copy_buffer-kerneldoc
+++ a/lib/scatterlist.c
@@ -832,7 +832,7 @@ EXPORT_SYMBOL(sg_miter_stop);
  * @buflen:		 The number of bytes to copy
  * @skip:		 Number of bytes to skip before copying
  * @to_buffer:		 transfer direction (true == from an sg list to a
- *			 buffer, false == from a buffer to an sg list
+ *			 buffer, false == from a buffer to an sg list)
  *
  * Returns the number of copied bytes.
  *
_

Patches currently in -mm which might be from geert+renesas@glider.be are
