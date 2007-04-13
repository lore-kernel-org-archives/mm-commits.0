From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-arch-ppc-syslib-cpc710h.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:29 -0700
Message-ID: <200704132328.l3DNSTTX012523@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60349 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030890AbXDMX2e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:28:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: arch/ppc/syslib/cpc710.h.
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-arch-ppc-syslib-cpc710h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove unused header file: arch/ppc/syslib/cpc710.h.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/syslib/cpc710.h |   81 -------------------------------------
 1 file changed, 81 deletions(-)

diff -puN arch/ppc/syslib/cpc710.h~remove-unused-header-file-arch-ppc-syslib-cpc710h /dev/null
--- a/arch/ppc/syslib/cpc710.h
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * Definitions for the IBM CPC710 PCI Host Bridge
- *
- * Author: Matt Porter <mporter@mvista.com>
- *
- * 2001 (c) MontaVista, Software, Inc.  This file is licensed under
- * the terms of the GNU General Public License version 2.  This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-
-#ifndef __PPC_PLATFORMS_CPC710_H
-#define __PPC_PLATFORMS_CPC710_H
-
-/* General bridge and memory controller registers */
-#define PIDR	0xff000008
-#define	CNFR	0xff00000c
-#define	RSTR	0xff000010
-#define UCTL	0xff001000
-#define	MPSR	0xff001010
-#define	SIOC	0xff001020
-#define	ABCNTL	0xff001030
-#define SRST	0xff001040
-#define	ERRC	0xff001050
-#define	SESR	0xff001060
-#define	SEAR	0xff001070
-#define	SIOC1	0xff001090
-#define	PGCHP	0xff001100
-#define	GPDIR	0xff001130
-#define	GPOUT	0xff001150
-#define	ATAS	0xff001160
-#define	AVDG	0xff001170
-#define	MCCR	0xff001200
-#define	MESR	0xff001220
-#define	MEAR	0xff001230
-#define	MCER0	0xff001300
-#define	MCER1	0xff001310
-#define	MCER2	0xff001320
-#define	MCER3	0xff001330
-#define	MCER4	0xff001340
-#define	MCER5	0xff001350
-#define	MCER6	0xff001360
-#define	MCER7	0xff001370
-
-/*
- * PCI32/64 configuration registers
- * Given as offsets from their
- * respective physical segment BAR
- */
-#define PIBAR	0x000f7800
-#define PMBAR	0x000f7810
-#define MSIZE	0x000f7f40
-#define IOSIZE	0x000f7f60
-#define SMBAR	0x000f7f80
-#define SIBAR	0x000f7fc0
-#define PSSIZE	0x000f8100
-#define PPSIZE	0x000f8110
-#define BARPS	0x000f8120
-#define BARPP	0x000f8130
-#define PSBAR	0x000f8140
-#define PPBAR	0x000f8150
-#define BPMDLK	0x000f8200      /* Bottom of Peripheral Memory Space */
-#define TPMDLK	0x000f8210      /* Top of Peripheral Memory Space */
-#define BIODLK	0x000f8220      /* Bottom of Peripheral I/O Space */
-#define TIODLK	0x000f8230      /* Top of Perioheral I/O Space */
-#define DLKCTRL	0x000f8240      /* Deadlock control */
-#define DLKDEV	0x000f8250      /* Deadlock device */
-
-/* System standard configuration registers space */
-#define	DCR	0xff200000
-#define	DID	0xff200004
-#define	BAR	0xff200018
-
-/* Device specific configuration space */
-#define	PCIENB	0xff201000
-
-/* Configuration space registers */
-#define CPC710_BUS_NUMBER	0x40
-#define CPC710_SUB_BUS_NUMBER	0x41
-
-#endif /* __PPC_PLATFORMS_CPC710_H */
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
