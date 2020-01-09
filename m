From: akpm@linux-foundation.org
Subject: [alternative-merged]
 bitops-more-bits_to_-macros-fix-fix.patch removed from -mm tree
Date: Thu, 09 Jan 2020 13:50:43 -0800
Message-ID: <20200109215043.pVPFwbwBv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgAIVuo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 16:50:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, akpm@linux-foundation.org, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: bitops-more-bits_to_-macros-fix-fix
has been removed from the -mm tree.  Its filename was
     bitops-more-bits_to_-macros-fix-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bitops-more-bits_to_-macros-fix-fix

convert	drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h

Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h~bitops-more-bits_to_-macros-fix-fix
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
@@ -17,6 +17,8 @@
 #ifndef BNX2X_INIT_H
 #define BNX2X_INIT_H
 
+#include <linux/bitops.h>
+
 /* Init operation types and structures */
 enum {
 	OP_RD = 0x1,	/* read a single register */
@@ -296,7 +298,6 @@ static inline void bnx2x_dcb_config_qm(s
  *    possible, the driver should only write the valid vnics into the internal
  *    ram according to the appropriate port mode.
  */
-#define BITS_TO_BYTES(x) ((x)/8)
 
 /* CMNG constants, as derived from system spec calculations */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-fix.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
