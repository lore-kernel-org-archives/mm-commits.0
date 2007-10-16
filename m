From: akpm@linux-foundation.org
Subject: - add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:22:40 -0700
Message-ID: <200710162222.l9GMMeJO020747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756455AbXJPWWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:22:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     add-a-rounddown_pow_of_two-routine-to-log2h.patch fix
has been removed from the -mm tree.  Its filename was
     add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch

This patch was dropped because it was folded into add-a-rounddown_pow_of_two-routine-to-log2h.patch

------------------------------------------------------
Subject: add-a-rounddown_pow_of_two-routine-to-log2h.patch fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

	This patch fixes the unbalanced parenthesis inroduced by
add-a-rounddown_pow_of_two-routine-to-log2h.patch.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/log2.h~add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix include/linux/log2.h
--- a/include/linux/log2.h~add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix
+++ a/include/linux/log2.h
@@ -186,7 +186,7 @@ unsigned long __rounddown_pow_of_two(uns
 (						\
 	__builtin_constant_p(n) ? (		\
 		(n == 1) ? 0 :			\
-		(1UL << ilog2(n)) :		\
+		(1UL << ilog2(n))) :		\
 	__rounddown_pow_of_two(n)		\
  )
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2h.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
