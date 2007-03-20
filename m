From: akpm@linux-foundation.org
Subject: + drivers-scsi-eata_generich-remove-false-true-defines.patch added to -mm tree
Date: Mon, 19 Mar 2007 23:20:02 -0800
Message-ID: <200703200720.l2K7K2pU028325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51085 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbXCTHUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Mar 2007 03:20:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se


The patch titled
     drivers/scsi/eata_generic.h: Remove FALSE/TRUE defines
has been added to the -mm tree.  Its filename is
     drivers-scsi-eata_generich-remove-false-true-defines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
drivers-scsi-eata_generich-remove-false-true-defines.patch
usb-serial-io_edgeport-convert-to-generic-boolean.patch
usb-serial-whiteheat-convert-to-generic-boolean.patch
