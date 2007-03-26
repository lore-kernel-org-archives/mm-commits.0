From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch removed from -mm tree
Date: Mon, 26 Mar 2007 15:35:13 -0800
Message-ID: <200703262335.l2QNZDEg001154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59006 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933784AbXCZXfY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 19:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: drivers/net/wan/lmc/lmc_media.h
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove unused header file: drivers/net/wan/lmc/lmc_media.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/lmc/lmc_media.h |   65 ------------------------------
 1 file changed, 65 deletions(-)

diff -puN drivers/net/wan/lmc/lmc_media.h~remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah /dev/null
--- a/drivers/net/wan/lmc/lmc_media.h
+++ /dev/null
@@ -1,65 +0,0 @@
-#ifndef _LMC_MEDIA_H_
-#define _LMC_MEDIA_H_
-
-lmc_media_t lmc_ds3_media = {
-  lmc_ds3_init,			/* special media init stuff */
-  lmc_ds3_default,		/* reset to default state */
-  lmc_ds3_set_status,		/* reset status to state provided */
-  lmc_dummy_set_1,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_ds3_set_100ft,		/* set cable length */
-  lmc_ds3_set_scram,		/* set scrambler */
-  lmc_ds3_get_link_status,	/* get link status */
-  lmc_dummy_set_1,		/* set link status */
-  lmc_ds3_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_ds3_watchdog
-};
-
-lmc_media_t lmc_hssi_media = {
-  lmc_hssi_init,		/* special media init stuff */
-  lmc_hssi_default,		/* reset to default state */
-  lmc_hssi_set_status,		/* reset status to state provided */
-  lmc_hssi_set_clock,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_hssi_get_link_status,	/* get link status */
-  lmc_hssi_set_link_status,	/* set link status */
-  lmc_hssi_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_hssi_watchdog
-};
-
-lmc_media_t lmc_ssi_media = { lmc_ssi_init,	/* special media init stuff */
-  lmc_ssi_default,		/* reset to default state */
-  lmc_ssi_set_status,		/* reset status to state provided */
-  lmc_ssi_set_clock,		/* set clock source */
-  lmc_ssi_set_speed,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_ssi_get_link_status,	/* get link status */
-  lmc_ssi_set_link_status,	/* set link status */
-  lmc_ssi_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_ssi_watchdog
-};
-
-lmc_media_t lmc_t1_media = {
-  lmc_t1_init,			/* special media init stuff */
-  lmc_t1_default,		/* reset to default state */
-  lmc_t1_set_status,		/* reset status to state provided */
-  lmc_t1_set_clock,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_t1_get_link_status,	/* get link status */
-  lmc_dummy_set_1,		/* set link status */
-  lmc_t1_set_crc_length,	/* set CRC length */
-  lmc_t1_set_circuit_type,	/* set T1 or E1 circuit type */
-  lmc_t1_watchdog
-};
-
-
-#endif
-
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-input.patch
git-mtd.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
pcmcia-allow-pcmcia-scsi-drivers-to-be-built-into-the.patch
git-scsi-misc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
