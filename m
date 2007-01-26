From: akpm@osdl.org
Subject: + correct-apparent-typo-config_aty_ct-in-aty-video.patch added to -mm tree
Date: Fri, 26 Jan 2007 13:05:48 -0800
Message-ID: <200701262105.l0QL5m49026519@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55208 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbXAZVGD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 16:06:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, adaplas@gmail.com, jsimmons@infradead.org, syrjala@sci.fi


The patch titled
     Correct apparent typo CONFIG_ATY_CT in ATY video
has been added to the -mm tree.  Its filename is
     correct-apparent-typo-config_aty_ct-in-aty-video.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Correct apparent typo CONFIG_ATY_CT in ATY video
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the apparent typo CONFIG_ATY_CT with CONFIG_FB_ATY_CT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

fix-various-kernel-doc-in-header-files.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
git-alsa.patch
remove-useless-reference-to-obsolete-kerneld.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
remove-unused-kernel-config-option-x86_xadd.patch
uml-fix-apparent-config_64_bit-typo.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
