From: akpm@linux-foundation.org
Subject: + add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch added to -mm tree
Date: Tue, 11 Sep 2007 20:42:29 -0700
Message-ID: <200709120342.l8C3gTeT014560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762742AbXILDmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 23:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, rpjday@mindspring.com


The patch titled
     add-a-rounddown_pow_of_two-routine-to-log2h.patch fix
has been added to the -mm tree.  Its filename is
     add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-alsa.patch
arm-unbalanced-parenthesis-fix.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
git-mmc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
git-v9fs.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
