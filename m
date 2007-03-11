From: akpm@linux-foundation.org
Subject: + remove-unused-header-file-drivers-char-drm-via_mmh.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:22:40 -0800
Message-ID: <200703110722.l2B7Me9k006901@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38603 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbXCKHWs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:22:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, airlied@linux.ie


The patch titled
     remove unused header file: drivers/char/drm/via_mm.h
has been added to the -mm tree.  Its filename is
     remove-unused-header-file-drivers-char-drm-via_mmh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove unused header file: drivers/char/drm/via_mm.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/via_mm.h |   40 ------------------------------------
 1 file changed, 40 deletions(-)

diff -puN drivers/char/drm/via_mm.h~remove-unused-header-file-drivers-char-drm-via_mmh /dev/null
--- a/drivers/char/drm/via_mm.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright 1998-2003 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2003 S3 Graphics, Inc. All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sub license,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice (including the
- * next paragraph) shall be included in all copies or substantial portions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
- * VIA, S3 GRAPHICS, AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- */
-#ifndef _via_drm_mm_h_
-#define _via_drm_mm_h_
-
-typedef struct {
-	unsigned int context;
-	unsigned int size;
-	unsigned long offset;
-	unsigned long free;
-} drm_via_mm_t;
-
-typedef struct {
-	unsigned int size;
-	unsigned long handle;
-	void *virtual;
-} drm_via_dma_t;
-
-#endif
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
