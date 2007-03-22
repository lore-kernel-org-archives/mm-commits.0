From: akpm@linux-foundation.org
Subject: - drivers-scsi-eata_generich-remove-false-true-defines.patch removed from -mm tree
Date: Thu, 22 Mar 2007 12:21:16 -0800
Message-ID: <200703222021.l2MKLGvD029445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933594AbXCVUVX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/eata_generic.h: Remove FALSE/TRUE defines
has been removed from the -mm tree.  Its filename was
     drivers-scsi-eata_generich-remove-false-true-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/eata_generic.h: Remove FALSE/TRUE defines
From: Richard Knutsson <ricknu-0@student.ltu.se>

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/eata_generic.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/scsi/eata_generic.h~drivers-scsi-eata_generich-remove-false-true-defines drivers/scsi/eata_generic.h
--- a/drivers/scsi/eata_generic.h~drivers-scsi-eata_generich-remove-false-true-defines
+++ a/drivers/scsi/eata_generic.h
@@ -18,13 +18,6 @@
  * Misc. definitions			     *
  *********************************************/
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #define R_LIMIT 0x20000
 
 #define MAXISA	   4
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

drivers-char-agp-convert-to-generic-boolean.patch
git-netdev-all.patch
git-scsi-misc.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
usb-serial-whiteheat-convert-to-generic-boolean.patch
