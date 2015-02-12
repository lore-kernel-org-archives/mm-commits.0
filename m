From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 14:19:23 -0800
Message-ID: <54dd26eb.FsHUxS5JCK/JW9ad%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbBLWTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:19:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix
has been removed from the -mm tree.  Its filename was
     lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch

This patch was dropped because it was folded into lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix

fix kerneldoc

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix
+++ a/lib/bitmap.c
@@ -1039,7 +1039,7 @@ EXPORT_SYMBOL(bitmap_onto);
  *	@dst: resulting smaller bitmap
  *	@orig: original larger bitmap
  *	@sz: specified size
- *	@bits: number of bits in each of these bitmaps
+ *	@nbits: number of bits in each of these bitmaps
  *
  * For each bit oldbit in @orig, set bit oldbit mod @sz in @dst.
  * Clear all other bits in @dst.  See further the comment and
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
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

