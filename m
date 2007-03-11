From: akpm@linux-foundation.org
Subject: + remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:22:56 -0800
Message-ID: <200703110722.l2B7MuBx006916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38618 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbXCKHXC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:23:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     remove unused header file: arch/powerpc/platforms/83xx/mpc834x_itx.h
has been added to the -mm tree.  Its filename is
     remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
