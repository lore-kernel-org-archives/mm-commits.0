From: akpm@linux-foundation.org
Subject: + sis-warning-fixes-fix.patch added to -mm tree
Date: Wed, 07 Feb 2007 13:47:47 -0800
Message-ID: <200702072147.l17LllER028209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39572 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161443AbXBGVsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 16:48:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@redhat.com, jeff@garzik.org


The patch titled
     sis-warning-fixes-fix
has been added to the -mm tree.  Its filename is
     sis-warning-fixes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sis-warning-fixes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sis.c |    1 -
 drivers/ata/sata_sis.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/ata/pata_sis.c~sis-warning-fixes-fix drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~sis-warning-fixes-fix
+++ a/drivers/ata/pata_sis.c
@@ -34,7 +34,6 @@
 #include <linux/ata.h>
 #include "sis.h"
 
-#undef DRV_NAME		/* already defined in libata.h, for libata-core */
 #define DRV_NAME	"pata_sis"
 #define DRV_VERSION	"0.4.5"
 
diff -puN drivers/ata/sata_sis.c~sis-warning-fixes-fix drivers/ata/sata_sis.c
--- a/drivers/ata/sata_sis.c~sis-warning-fixes-fix
+++ a/drivers/ata/sata_sis.c
@@ -42,7 +42,6 @@
 #include <linux/libata.h>
 #include "sis.h"
 
-#undef DRV_NAME		/* already defined in libata.h, for libata-core */
 #define DRV_NAME	"sata_sis"
 #define DRV_VERSION	"0.7"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
sis-warning-fixes-fix.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
git-block.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
workqueue-dont-save-interrupts-in-run_workqueue-update.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
