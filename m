From: akpm@osdl.org
Subject: - video-neofb-stray-bracket-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:55 -0800
Message-ID: <200612082014.kB8KEtmY003226@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59889 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946857AbWLHUO7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     video: neofb stray bracket fix
has been removed from the -mm tree.  Its filename was
     video-neofb-stray-bracket-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: video: neofb stray bracket fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This code is '#if 0'ed.  Anyway if anyone wants to dump neo registers
better to have it fixed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/neofb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/neofb.c~video-neofb-stray-bracket-fix drivers/video/neofb.c
--- a/drivers/video/neofb.c~video-neofb-stray-bracket-fix
+++ a/drivers/video/neofb.c
@@ -1932,7 +1932,7 @@ static int __devinit neo_init_hw(struct 
 	printk(KERN_DEBUG "--- Neo extended register dump ---\n");
 	for (int w = 0; w < 0x85; w++)
 		printk(KERN_DEBUG "CR %p: %p\n", (void *) w,
-		       (void *) vga_rcrt(NULL, w);
+		       (void *) vga_rcrt(NULL, w));
 	for (int w = 0; w < 0xC7; w++)
 		printk(KERN_DEBUG "GR %p: %p\n", (void *) w,
 		       (void *) vga_rgfx(NULL, w));
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
video-neofb-stray-bracket-fix.patch
video-pm3fb-macros-fix.patch
ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
sparc64-dma-remove-extra-brackets.patch

