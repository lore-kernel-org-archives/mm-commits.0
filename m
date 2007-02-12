From: akpm@linux-foundation.org
Subject: - correct-apparent-typo-config_aty_ct-in-aty-video.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:43 -0800
Message-ID: <200702122249.l1CMnhu5014152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45690 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030391AbXBLWt5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, adaplas@gmail.com, jsimmons@infradead.org, syrjala@sci.fi, mm-commits@vger.kernel.org


The patch titled
     Correct apparent typo CONFIG_ATY_CT in ATY video
has been removed from the -mm tree.  Its filename was
     correct-apparent-typo-config_aty_ct-in-aty-video.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Correct apparent typo CONFIG_ATY_CT in ATY video
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the apparent typo CONFIG_ATY_CT with CONFIG_FB_ATY_CT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/atyfb_base.c~correct-apparent-typo-config_aty_ct-in-aty-video drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~correct-apparent-typo-config_aty_ct-in-aty-video
+++ a/drivers/video/aty/atyfb_base.c
@@ -2566,7 +2566,7 @@ static int __devinit aty_init(struct fb_
 	       info->fix.smem_len == 0x80000 ? 'K' : 'M', ramname, xtal, par->pll_limits.pll_max,
 	       par->pll_limits.mclk, par->pll_limits.xclk);
 
-#if defined(DEBUG) && defined(CONFIG_ATY_CT)
+#if defined(DEBUG) && defined(CONFIG_FB_ATY_CT)
 	if (M64_HAS(INTEGRATED)) {
 		int i;
 		printk("debug atyfb: BUS_CNTL DAC_CNTL MEM_CNTL EXT_MEM_CNTL CRTC_GEN_CNTL "
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
