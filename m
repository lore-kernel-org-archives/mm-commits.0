From: akpm@linux-foundation.org
Subject: + drivers-edac-add-rddr2-memory-types.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:50:27 -0700
Message-ID: <200706060150.l561oRXJ007426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933377AbXFFBue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers-edac: add RDDR2 memory types
has been added to the -mm tree.  Its filename is
     drivers-edac-add-rddr2-memory-types.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: add RDDR2 memory types
From: Douglas Thompson <dougthompson@xmission.com>

Add Registered RDDR2 memory types for displaying DDR2 memories

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/edac/edac_mc.h~drivers-edac-add-rddr2-memory-types drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~drivers-edac-add-rddr2-memory-types
+++ a/drivers/edac/edac_mc.h
@@ -126,6 +126,7 @@ enum mem_type {
 	MEM_RMBS,		/* Rambus DRAM */
 	MEM_DDR2,               /* DDR2 RAM */
 	MEM_FB_DDR2,            /* fully buffered DDR2 */
+	MEM_RDDR2,              /* Registered DDR2 RAM */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -141,6 +142,7 @@ enum mem_type {
 #define MEM_FLAG_RMBS		BIT(MEM_RMBS)
 #define MEM_FLAG_DDR2           BIT(MEM_DDR2)
 #define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
+#define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {
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
