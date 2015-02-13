From: akpm@linux-foundation.org
Subject: [merged] lib-plistc-remove-redundant-include.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:23:04 -0800
Message-ID: <54de5d28.6D+Q3k/fatPjyY7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbbBMUXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:23:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/plist.c: remove redundant include
has been removed from the -mm tree.  Its filename was
     lib-plistc-remove-redundant-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/plist.c: remove redundant include

Removing the include of linux/spinlock.h produces byte-identical output
for {allno,def}config, and identical objdump -d output for allyesconfig. 
In the former two cases, more than a 100 lines are eliminated from the
generated dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/plist.c~lib-plistc-remove-redundant-include lib/plist.c
--- a/lib/plist.c~lib-plistc-remove-redundant-include
+++ a/lib/plist.c
@@ -25,7 +25,6 @@
 
 #include <linux/bug.h>
 #include <linux/plist.h>
-#include <linux/spinlock.h>
 
 #ifdef CONFIG_DEBUG_PI_LIST
 
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

