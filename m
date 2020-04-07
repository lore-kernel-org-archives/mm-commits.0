From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 115/166] lib/scatterlist: fix sg_copy_buffer()
 kerneldoc
Date: Mon, 06 Apr 2020 20:10:09 -0700
Message-ID: <20200407031009.EWZ4Qzc6U%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgDGDKK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:10:10 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, akpm@linux-foundation.org, geert+renesas@glider.be, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
