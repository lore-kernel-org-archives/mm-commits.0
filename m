From: akpm@linux-foundation.org
Subject: + drivers-edac-coreh-fix-scrubdefs.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:50:43 -0700
Message-ID: <200706060150.l561oht0007446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933371AbXFFBuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers-edac: core.h fix scrubdefs
has been added to the -mm tree.  Its filename is
     drivers-edac-coreh-fix-scrubdefs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: core.h fix scrubdefs
From: Douglas Thompson <dougthompson@xmission.com>

Patch to fix some scrubbing #defines in the edac_core.h file

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-coreh-fix-scrubdefs drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-coreh-fix-scrubdefs
+++ a/drivers/edac/edac_core.h
@@ -194,12 +194,12 @@ enum scrub_type {
 };
 
 #define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
-#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC_CORR)
-#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC_CORR)
+#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC)
+#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC)
 #define SCRUB_FLAG_SW_TUN	BIT(SCRUB_SW_SCRUB_TUNABLE)
 #define SCRUB_FLAG_HW_PROG	BIT(SCRUB_HW_PROG)
-#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC_CORR)
-#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC_CORR)
+#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC)
+#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC)
 #define SCRUB_FLAG_HW_TUN	BIT(SCRUB_HW_TUNABLE)
 
 /* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-remove-depends-on-x86.patch
drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
