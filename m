From: akpm@linux-foundation.org
Subject: [merged] lib-llistc-remove-redundant-include.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:22:58 -0800
Message-ID: <54de5d22.ZjDEX79oLc6z6/Cu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbbBMUW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/llist.c: remove redundant include
has been removed from the -mm tree.  Its filename was
     lib-llistc-remove-redundant-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/llist.c: remove redundant include

This file doesn't seem to use anything provided by linux/interrupt.h or
anything recursively included through that.  Removing it produces
byte-identical output, while reducing .llist.o.cmd from 541 to 156 lines.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/llist.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/llist.c~lib-llistc-remove-redundant-include lib/llist.c
--- a/lib/llist.c~lib-llistc-remove-redundant-include
+++ a/lib/llist.c
@@ -24,7 +24,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/export.h>
-#include <linux/interrupt.h>
 #include <linux/llist.h>
 
 
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

