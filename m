From: akpm@osdl.org
Subject: - video-cyberfb-broken-macro-removal.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:52 -0800
Message-ID: <200612082014.kB8KEqHC003221@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946974AbWLHUO7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     video: cyberfb broken macro removal
has been removed from the -mm tree.  Its filename was
     video-cyberfb-broken-macro-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: video: cyberfb broken macro removal
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Remove broken and unused macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/cyberfb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/cyberfb.c~video-cyberfb-broken-macro-removal drivers/video/cyberfb.c
--- a/drivers/video/cyberfb.c~video-cyberfb-broken-macro-removal
+++ a/drivers/video/cyberfb.c
@@ -109,8 +109,6 @@ static void cv64_dump(void);
 #define wb_64(regs,reg,dat) (*(((volatile unsigned char *)regs) + reg) = dat)
 #define rb_64(regs, reg) (*(((volatile unsigned char *)regs) + reg))
 
-#define ww_64(regs,reg,dat) (*((volatile unsigned short *)(regs + reg) = dat)
-
 struct cyberfb_par {
 	struct fb_var_screeninfo var;
 	__u32 type;
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
video-cyberfb-broken-macro-removal.patch
video-neofb-stray-bracket-fix.patch
video-pm3fb-macros-fix.patch
ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
sparc64-dma-remove-extra-brackets.patch

