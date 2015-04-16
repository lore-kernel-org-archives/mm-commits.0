From: akpm@linux-foundation.org
Subject: [folded-merged] lib-find__bit-reimplementation-fix.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 11:59:51 -0700
Message-ID: <553006a7.aW0bNdD+Wldh95C8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbDPS7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 14:59:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-find__bit-reimplementation-fix
has been removed from the -mm tree.  Its filename was
     lib-find__bit-reimplementation-fix.patch

This patch was dropped because it was folded into lib-find__bit-reimplementation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-find__bit-reimplementation-fix

include linux/bitmap.h, per Rasmus

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_last_bit.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/find_last_bit.c~lib-find__bit-reimplementation-fix lib/find_last_bit.c
--- a/lib/find_last_bit.c~lib-find__bit-reimplementation-fix
+++ a/lib/find_last_bit.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch

