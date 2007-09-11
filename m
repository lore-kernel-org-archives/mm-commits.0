From: akpm@linux-foundation.org
Subject: + arm-unbalanced-parenthesis-fix.patch added to -mm tree
Date: Mon, 10 Sep 2007 21:53:02 -0700
Message-ID: <200709110453.l8B4r2Uh026145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbXIKExY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 00:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, rmk@arm.linux.org.uk


The patch titled
     arm: unbalanced parenthesis fix
has been added to the -mm tree.  Its filename is
     arm-unbalanced-parenthesis-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arm: unbalanced parenthesis fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Fix unbalanced parenthesis.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-sa1100/SA-1101.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-arm/arch-sa1100/SA-1101.h~arm-unbalanced-parenthesis-fix include/asm-arm/arch-sa1100/SA-1101.h
--- a/include/asm-arm/arch-sa1100/SA-1101.h~arm-unbalanced-parenthesis-fix
+++ a/include/asm-arm/arch-sa1100/SA-1101.h
@@ -106,7 +106,7 @@
 #define SMCR_ColAdrBits( x )		  /* col. addr bits 8..11 */ \
 	(( (x) - 8 ) << FShft (SMCR_DCAC))
 #define SMCR_RowAdrBits( x )		  /* row addr bits 9..12 */\
-	(( (x) - 9 ) << FShft (SMCR_DRAC)
+	(( (x) - 9 ) << FShft (SMCR_DRAC))
 
 #define SNPR_VFBstart	  Fld(12,0)	/* Video frame buffer addr */
 #define SNPR_VFBsize	  Fld(11,12)	/* Video frame buffer size */
@@ -394,7 +394,7 @@
 #define VgaStatus      (*((volatile Word *) SA1101_p2v (_VgaStatus)))
 #define VgaInterruptMask (*((volatile Word *) SA1101_p2v (_VgaInterruptMask)))
 #define VgaPalette     (*((volatile Word *) SA1101_p2v (_VgaPalette)))
-#define DacControl     (*((volatile Word *) SA1101_p2v (_DacControl))
+#define DacControl     (*((volatile Word *) SA1101_p2v (_DacControl)))
 #define VgaTest        (*((volatile Word *) SA1101_p2v (_VgaTest)))
 
 #define VideoControl_VgaEn    0x00000000
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
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
