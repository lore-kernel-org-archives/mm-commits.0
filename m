From: akpm@linux-foundation.org
Subject: + skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch added to -mm tree
Date: Mon, 10 Sep 2007 21:52:16 -0700
Message-ID: <200709110452.l8B4qGgg026136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbXIKEw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 00:52:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, jeff@garzik.org, shemminger@linux-foundation.org


The patch titled
     skge: remove broken and unused PHY_M_PC_MDI_XMODE macro
has been added to the -mm tree.  Its filename is
     skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: skge: remove broken and unused PHY_M_PC_MDI_XMODE macro
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skge.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/skge.h~skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro drivers/net/skge.h
--- a/drivers/net/skge.h~skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro
+++ a/drivers/net/skge.h
@@ -1351,8 +1351,6 @@ enum {
 	PHY_M_PC_EN_DET_PLUS	= 3<<8, /* Energy Detect Plus (Mode 2) */
 };
 
-#define PHY_M_PC_MDI_XMODE(x)	((((u16)(x)<<5) & PHY_M_PC_MDIX_MSK)
-
 enum {
 	PHY_M_PC_MAN_MDI	= 0, /* 00 = Manual MDI configuration */
 	PHY_M_PC_MAN_MDIX	= 1, /* 01 = Manual MDIX configuration */
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
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
