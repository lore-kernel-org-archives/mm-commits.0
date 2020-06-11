From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch removed from
 -mm tree
Date: Wed, 10 Jun 2020 18:20:07 -0700
Message-ID: <20200611012007.FoN5zPlub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgFKBUI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, geert@linux-m68k.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: lib-test-get_count_order-long-in-test_bitopsc-fix-fix
has been removed from the -mm tree.  Its filename was
     lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch

This patch was dropped because it was folded into lib-test-get_count_order-long-in-test_bitopsc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test-get_count_order-long-in-test_bitopsc-fix-fix

fix loop bound, per Wei Yang

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_bitops.c~lib-test-get_count_order-long-in-test_bitopsc-fix-fix
+++ a/lib/test_bitops.c
@@ -74,7 +74,7 @@ static int __init test_bitops_startup(vo
 	}
 
 #ifdef CONFIG_64BIT
-	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
+	for (i = 0; i < ARRAY_SIZE(order_comb_long); i++) {
 		if (order_comb_long[i][1] !=
 			       get_count_order_long(order_comb_long[i][0]))
 			pr_warn("get_count_order_long wrong for %lx\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-test-get_count_order-long-in-test_bitopsc.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
arch-powerpc-mm-pgtablec-another-missed-conversion.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
kernel-forkc-export-kernel_thread-to-modules.patch
