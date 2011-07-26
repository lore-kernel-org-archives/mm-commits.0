From: akpm@linux-foundation.org
Subject: [merged] lib-lcmc-quiet-sparse-noise.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:55 -0700
Message-ID: <201107260754.p6Q7swRl003397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab1GZHzq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     lib/lcm.c: quiet sparse noise
has been removed from the -mm tree.  Its filename was
     lib-lcmc-quiet-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/lcm.c: quiet sparse noise
From: H Hartley Sweeten <hartleys@visionengravers.com>

The symbol 'lcm' is exported to the kernel (EXPORT_SYMBOL_GPL).
Pick up it's definition in <linux/lcm.h> to quiet the sparse noise:

  warning: symbol 'lcm' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lcm.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/lcm.c~lib-lcmc-quiet-sparse-noise lib/lcm.c
--- a/lib/lcm.c~lib-lcmc-quiet-sparse-noise
+++ a/lib/lcm.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/gcd.h>
 #include <linux/module.h>
+#include <linux/lcm.h>
 
 /* Lowest common multiple */
 unsigned long lcm(unsigned long a, unsigned long b)
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
drivers-block-drbd-drbd_nlc-use-bitmap_parse-instead-of-__bitmap_parse.patch

