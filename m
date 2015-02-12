From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 14:19:05 -0800
Message-ID: <54dd26d9.BYCdCSvFOJqJdi7M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbbBLWTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:19:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-bitmap-update-bitmap_onto-to-unsigned.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes

WARNING: please, no space before tabs
#38: FILE: lib/bitmap.c:1011:
+^Iunsigned int n, m;       ^I/* same meaning as in above comment */$

total: 0 errors, 1 warnings, 19 lines checked

./patches/lib-bitmap-update-bitmap_onto-to-unsigned.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes
+++ a/lib/bitmap.c
@@ -1008,7 +1008,7 @@ EXPORT_SYMBOL(bitmap_bitremap);
 void bitmap_onto(unsigned long *dst, const unsigned long *orig,
 			const unsigned long *relmap, unsigned int bits)
 {
-	unsigned int n, m;       	/* same meaning as in above comment */
+	unsigned int n, m;	/* same meaning as in above comment */
 
 	if (dst == orig)	/* following doesn't handle inplace mappings */
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
zram-rework-reset-and-destroy-path.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch
kernelh-remove-ancient-__function__-hack.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

