From: akpm@linux-foundation.org
Subject: +
 linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
 added to -mm tree
Date: Thu, 05 Jan 2017 17:30:42 -0800
Message-ID: <586ef342.faDgiVKueaJ7l9ZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42120 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdAFB3Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 20:29:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@roeck-us.net, niklas.soderlund+renesas@ragnatech.se, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix
has been added to the -mm tree.  Its filename is
     linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix

fix comment, per Guenter

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kernel.h~linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix
+++ a/include/linux/kernel.h
@@ -102,7 +102,7 @@
 /*
  * Divide positive or negative dividend by positive or negative divisor
  * and round to closest integer. Result is undefined for negative
- * divisors if dividends variable type is unsigned and for negative
+ * divisors if he dividend variable type is unsigned and for negative
  * dividends if the divisor variable type is unsigned.
  */
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

