From: akpm@linux-foundation.org
Subject: - arm26-remove-useless-config-option-generic_bust_spinlock.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:10 -0700
Message-ID: <200705080005.l4805ArJ009072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967456AbXEHAJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     ARM26: remove useless config option GENERIC_BUST_SPINLOCK.
has been removed from the -mm tree.  Its filename was
     arm26-remove-useless-config-option-generic_bust_spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM26: remove useless config option GENERIC_BUST_SPINLOCK.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the apparently useless config option GENERIC_BUST_SPINLOCK,
since nothing in the source tree refers to it.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/arm26/Kconfig~arm26-remove-useless-config-option-generic_bust_spinlock arch/arm26/Kconfig
--- a/arch/arm26/Kconfig~arm26-remove-useless-config-option-generic_bust_spinlock
+++ a/arch/arm26/Kconfig
@@ -57,9 +57,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_BUST_SPINLOCK
-	bool
-
 config ZONE_DMA
 	bool
 	default y
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-r8169.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
