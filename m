From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:31 -0700
Message-ID: <200704132328.l3DNSV24012526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60353 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030892AbXDMX2f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: arch/powerpc/platforms/83xx/mpc834x_itx.h
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove unused header file: arch/powerpc/platforms/83xx/mpc834x_itx.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/83xx/mpc834x_itx.h |   23 --------------------
 1 file changed, 23 deletions(-)

diff -puN arch/powerpc/platforms/83xx/mpc834x_itx.h~remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh /dev/null
--- a/arch/powerpc/platforms/83xx/mpc834x_itx.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * arch/powerpc/platforms/83xx/mpc834x_itx.h
- *
- * MPC834X ITX common board definitions
- *
- * Maintainer: Kumar Gala <galak@kernel.crashing.org>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- */
-
-#ifndef __MACH_MPC83XX_ITX_H__
-#define __MACH_MPC83XX_ITX_H__
-
-#define PIRQA	MPC83xx_IRQ_EXT4
-#define PIRQB	MPC83xx_IRQ_EXT5
-#define PIRQC	MPC83xx_IRQ_EXT6
-#define PIRQD	MPC83xx_IRQ_EXT7
-
-#endif				/* __MACH_MPC83XX_ITX_H__ */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
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
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
