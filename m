From: akpm@linux-foundation.org
Subject: - delete-unused-header-file-sound-pci-au88x0-au88x0_sbh.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:57 -0800
Message-ID: <200703152156.l2FLuvaA027600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42309 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbXCOV5E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Delete unused header file sound/pci/au88x0/au88x0_sb.h
has been removed from the -mm tree.  Its filename was
     delete-unused-header-file-sound-pci-au88x0-au88x0_sbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Delete unused header file sound/pci/au88x0/au88x0_sb.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/au88x0/au88x0_sb.h |   40 ---------------------------------
 1 file changed, 40 deletions(-)

diff -puN sound/pci/au88x0/au88x0_sb.h~delete-unused-header-file-sound-pci-au88x0-au88x0_sbh /dev/null
--- a/sound/pci/au88x0/au88x0_sb.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/***************************************************************************
- *            au88x0_sb.h
- *
- *  Wed Oct 29 22:10:42 2003
- *  
- ****************************************************************************/
-
-#ifdef CHIP_AU8820
-/* AU8820 starting @ 64KiB offset */
-#define SBEMU_BASE 0x10000
-#else
-/* AU8810? and AU8830 starting @ 164KiB offset */
-#define SBEMU_BASE 0x29000
-#endif
-
-#define FM_A_STATUS			(SBEMU_BASE + 0x00)	/* read */
-#define FM_A_ADDRESS		(SBEMU_BASE + 0x00)	/* write */
-#define FM_A_DATA			(SBEMU_BASE + 0x04)
-#define FM_B_STATUS			(SBEMU_BASE + 0x08)
-#define FM_B_ADDRESS		(SBEMU_BASE + 0x08)
-#define FM_B_DATA			(SBEMU_BASE + 0x0C)
-#define SB_MIXER_ADDR		(SBEMU_BASE + 0x10)
-#define SB_MIXER_DATA		(SBEMU_BASE + 0x14)
-#define SB_RESET			(SBEMU_BASE + 0x18)
-#define SB_RESET_ALIAS		(SBEMU_BASE + 0x1C)
-#define FM_STATUS2			(SBEMU_BASE + 0x20)
-#define FM_ADDR2			(SBEMU_BASE + 0x20)
-#define FM_DATA2			(SBEMU_BASE + 0x24)
-#define SB_DSP_READ			(SBEMU_BASE + 0x28)
-#define SB_DSP_WRITE		(SBEMU_BASE + 0x30)
-#define SB_DSP_WRITE_STATUS	(SBEMU_BASE + 0x30)	/* bit 7 */
-#define SB_DSP_READ_STATUS	(SBEMU_BASE + 0x38)	/* bit 7 */
-#define SB_LACR				(SBEMU_BASE + 0x40)	/* ? */
-#define SB_LADCR			(SBEMU_BASE + 0x44)	/* ? */
-#define SB_LAMR				(SBEMU_BASE + 0x48)	/* ? */
-#define SB_LARR				(SBEMU_BASE + 0x4C)	/* ? */
-#define SB_VERSION			(SBEMU_BASE + 0x50)
-#define SB_CTRLSTAT			(SBEMU_BASE + 0x54)
-#define SB_TIMERSTAT		(SBEMU_BASE + 0x58)
-#define FM_RAM				(SBEMU_BASE + 0x100)	/* 0x40 ULONG */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-avr32.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
ppc-correct-apparently-misspelled-xmon-preprocessor.patch
git-drm.patch
git-mtd.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
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
