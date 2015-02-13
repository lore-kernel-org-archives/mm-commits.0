From: akpm@linux-foundation.org
Subject: [merged] lib-lcmc-replace-include.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:29:39 -0800
Message-ID: <54de5eb3.ugn2AKuSBvGiCHYk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbbBMU3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lcm.c: replace include
has been removed from the -mm tree.  Its filename was
     lib-lcmc-replace-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/lcm.c: replace include

We don't need all the stuff kernel.h pulls in; just compiler.h since
export.h doesn't do necessary #includes.  This removes more than 100
dependencies.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/lcm.c~lib-lcmc-replace-include lib/lcm.c
--- a/lib/lcm.c~lib-lcmc-replace-include
+++ a/lib/lcm.c
@@ -1,4 +1,4 @@
-#include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/gcd.h>
 #include <linux/export.h>
 #include <linux/lcm.h>
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

