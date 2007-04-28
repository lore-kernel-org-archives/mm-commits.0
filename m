From: akpm@linux-foundation.org
Subject: + arm-remove-useless-config-option-generic_bust_spinlock.patch added to -mm tree
Date: Sat, 28 Apr 2007 01:09:59 -0700
Message-ID: <200704280809.l3S89xGV017748@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161590AbXD1IKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 04:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, rmk@arm.linux.org.uk


The patch titled
     ARM: remove useless config option GENERIC_BUST_SPINLOCK
has been added to the -mm tree.  Its filename is
     arm-remove-useless-config-option-generic_bust_spinlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARM: remove useless config option GENERIC_BUST_SPINLOCK
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the apparently useless config option GENERIC_BUST_SPINLOCK,
since nothing in the source tree refers to it.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/arm/Kconfig~arm-remove-useless-config-option-generic_bust_spinlock arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-remove-useless-config-option-generic_bust_spinlock
+++ a/arch/arm/Kconfig
@@ -106,9 +106,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_BUST_SPINLOCK
-	bool
-
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-powerpc.patch
git-drm.patch
git-infiniband.patch
git-input.patch
git-mtd.patch
git-netdev-all.patch
3c509-remove-unnecessary-include-of-linux-pm_legacyh.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
arm26-remove-useless-config-option-generic_bust_spinlock.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
cris-remove-code-related-to-pre-22-kernel.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
clarify-the-creation-of-the-localversion_auto-string.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
