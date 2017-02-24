From: akpm@linux-foundation.org
Subject: [folded-merged]
 linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:44:23 -0800
Message-ID: <58b0b747.cvGodTDwf/evyZBh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWoZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:44:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@roeck-us.net, niklas.soderlund+renesas@ragnatech.se, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix
has been removed from the -mm tree.  Its filename was
     linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch

This patch was dropped because it was folded into linux-kernelh-fix-div_round_closest-to-support-negative-divisors.patch

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

mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix-fix.patch
lib-update-lz4-compressor-module-fix-fix-fix.patch

