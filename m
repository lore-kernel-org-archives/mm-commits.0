From: akpm@linux-foundation.org
Subject: + drivers-edac-mc-sysfs-add-missing-mem-types.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:50:37 -0700
Message-ID: <200706060150.l561obGp007437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50557 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933553AbXFFBux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com, dougthompson@xmission.com


The patch titled
     drivers-edac: mc sysfs add missing mem types
has been added to the -mm tree.  Its filename is
     drivers-edac-mc-sysfs-add-missing-mem-types.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: mc sysfs add missing mem types
From: Dave Jiang <djiang@mvista.com>

Adding missing mem types for use in the sysfs presentation file for
Memory Controller device objects.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc_sysfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-mc-sysfs-add-missing-mem-types drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-mc-sysfs-add-missing-mem-types
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -67,7 +67,10 @@ static const char *mem_types[] = {
 	[MEM_RDR] = "Registered-SDR",
 	[MEM_DDR] = "Unbuffered-DDR",
 	[MEM_RDDR] = "Registered-DDR",
-	[MEM_RMBS] = "RMBS"
+	[MEM_RMBS] = "RMBS",
+	[MEM_DDR2] = "Unbuffered-DDR2",
+	[MEM_FB_DDR2] = "FullyBuffered-DDR2",
+	[MEM_RDDR2] = "Registered-DDR2"
 };
 
 static const char *dev_types[] = {
_

Patches currently in -mm which might be from djiang@mvista.com are

drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-mod-pci-poll-names.patch
drivers-edac-core-lindent-cleanup.patch
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
