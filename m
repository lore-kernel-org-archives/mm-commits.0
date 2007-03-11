From: akpm@linux-foundation.org
Subject: + remove-unused-header-file-arch-m68k-atari-atasoundh.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:23:00 -0800
Message-ID: <200703110723.l2B7N04h006919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXCKHXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     remove unused header file: arch/m68k/atari/atasound.h
has been added to the -mm tree.  Its filename is
     remove-unused-header-file-arch-m68k-atari-atasoundh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove unused header file: arch/m68k/atari/atasound.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/atari/atasound.h |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff -puN arch/m68k/atari/atasound.h~remove-unused-header-file-arch-m68k-atari-atasoundh /dev/null
--- a/arch/m68k/atari/atasound.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Minor numbers for the sound driver.
- *
- * Unfortunately Creative called the codec chip of SB as a DSP. For this
- * reason the /dev/dsp is reserved for digitized audio use. There is a
- * device for true DSP processors but it will be called something else.
- * In v3.0 it's /dev/sndproc but this could be a temporary solution.
- */
-
-#define SND_NDEVS	256	/* Number of supported devices */
-#define SND_DEV_CTL	0	/* Control port /dev/mixer */
-#define SND_DEV_SEQ	1	/* Sequencer output /dev/sequencer (FM
-				   synthesizer and MIDI output) */
-#define SND_DEV_MIDIN	2	/* Raw midi access */
-#define SND_DEV_DSP	3	/* Digitized voice /dev/dsp */
-#define SND_DEV_AUDIO	4	/* Sparc compatible /dev/audio */
-#define SND_DEV_DSP16	5	/* Like /dev/dsp but 16 bits/sample */
-#define SND_DEV_STATUS	6	/* /dev/sndstat */
-/* #7 not in use now. Was in 2.4. Free for use after v3.0. */
-#define SND_DEV_SEQ2	8	/* /dev/sequencer, level 2 interface */
-#define SND_DEV_SNDPROC 9	/* /dev/sndproc for programmable devices */
-#define SND_DEV_PSS	SND_DEV_SNDPROC
-
-#define DSP_DEFAULT_SPEED	8000
-
-#define ON		1
-#define OFF		0
-
-#define MAX_AUDIO_DEV	5
-#define MAX_MIXER_DEV	2
-#define MAX_SYNTH_DEV	3
-#define MAX_MIDI_DEV	6
-#define MAX_TIMER_DEV	3
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
mtd-correct-misspelled-preprocessor-variable.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-sound-pci-cs46xx-imgs-cwcemb80h.patch
remove-unused-header-file-include-linux-elfnoteh.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-message-fusion-lsi-mpi_inbh-and-drivers-message-fusion-lsi-mpi_log_fch.patch
remove-unused-header-file-drivers-char-drm-via_mmh.patch
remove-unused-header-file-drivers-char-digih.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
