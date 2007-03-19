From: akpm@linux-foundation.org
Subject: - ppc-correct-apparently-misspelled-xmon-preprocessor.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:03:59 -0800
Message-ID: <200703192203.l2JM3xgw018919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58719 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030696AbXCSWEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     PPC: correct apparently misspelled "XMON" preprocessor directive
has been removed from the -mm tree.  Its filename was
     ppc-correct-apparently-misspelled-xmon-preprocessor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PPC: correct apparently misspelled "XMON" preprocessor directive
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/chrp/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/chrp/setup.c~ppc-correct-apparently-misspelled-xmon-preprocessor arch/powerpc/platforms/chrp/setup.c
--- a/arch/powerpc/platforms/chrp/setup.c~ppc-correct-apparently-misspelled-xmon-preprocessor
+++ a/arch/powerpc/platforms/chrp/setup.c
@@ -427,7 +427,7 @@ static void __init chrp_find_openpic(voi
 	of_node_put(np);
 }
 
-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 static struct irqaction xmon_irqaction = {
 	.handler = xmon_irq,
 	.mask = CPU_MASK_NONE,
@@ -493,7 +493,7 @@ static void __init chrp_find_8259(void)
 
 void __init chrp_init_IRQ(void)
 {
-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 	struct device_node *kbd;
 #endif
 	chrp_find_openpic();
@@ -510,7 +510,7 @@ void __init chrp_init_IRQ(void)
 	if (_chrp_type == _CHRP_Pegasos)
 		ppc_md.get_irq        = i8259_irq;
 
-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 	/* see if there is a keyboard in the device tree
 	   with a parent of type "adb" */
 	for (kbd = find_devices("keyboard"); kbd; kbd = kbd->next)
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-avr32.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-mtd.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-include-linux-elfnoteh.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
