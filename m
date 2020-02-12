From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-scatterlist-fix-sg_copy_buffer-kerneldoc.patch
 added to -mm tree
Date: Wed, 12 Feb 2020 14:34:46 -0800
Message-ID: <20200212223446.lqOSJXugr%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbgBLWer (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 17:34:47 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: fix sg_copy_buffer() kerneldoc
has been added to the -mm tree.  Its filename is
     lib-scatterlist-fix-sg_copy_buffer-kerneldoc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-fix-sg_copy_buffer-kerneldoc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-fix-sg_copy_buffer-kerneldoc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-scatterlist-fix-sg_copy_buffer-kerneldoc.patch
