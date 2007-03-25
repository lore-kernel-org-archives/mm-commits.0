From: akpm@linux-foundation.org
Subject: - delete-unused-header-file-media-wm8775h.patch removed from -mm tree
Date: Sun, 25 Mar 2007 13:56:28 -0800
Message-ID: <200703252156.l2PLuSit003768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59432 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbXCYV4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 17:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Delete unused header file media/wm8775.h
has been removed from the -mm tree.  Its filename was
     delete-unused-header-file-media-wm8775h.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: Delete unused header file media/wm8775.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/media/wm8775.h |   35 -----------------------------------
 1 file changed, 35 deletions(-)

diff -puN include/media/wm8775.h~delete-unused-header-file-media-wm8775h /dev/null
--- a/include/media/wm8775.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
-    wm8775.h - definition for wm8775 inputs and outputs
-
-    Copyright (C) 2006 Hans Verkuil (hverkuil@xs4all.nl)
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#ifndef _WM8775_H_
-#define _WM8775_H_
-
-/* The WM8775 has 4 inputs and one output. Zero or more inputs
-   are multiplexed together to the output. Hence there are
-   16 combinations.
-   If only one input is active (the normal case) then the
-   input values 1, 2, 4 or 8 should be used. */
-
-#define WM8775_AIN1 1
-#define WM8775_AIN2 2
-#define WM8775_AIN3 4
-#define WM8775_AIN4 8
-
-#endif
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
delete-unused-header-file-media-cs53l32ah.patch
delete-unused-header-file-media-wm8775h.patch
git-mtd.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
mtd-delete-unused-header-file-linux-mtd-iflashh.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
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
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-linux-awe_voiceh.patch
delete-unused-header-file-math-emu-extendedh.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
