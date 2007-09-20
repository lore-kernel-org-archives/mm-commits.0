From: akpm@linux-foundation.org
Subject: - arm-unbalanced-parenthesis-fix.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:16:13 -0700
Message-ID: <200709202116.l8KLGDKD002997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbXITV2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: unbalanced parenthesis fix
has been removed from the -mm tree.  Its filename was
     arm-unbalanced-parenthesis-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-arm.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
git-mmc.patch
git-mtd.patch
git-net.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
