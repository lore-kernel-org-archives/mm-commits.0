From: akpm@linux-foundation.org
Subject: - drivers-edac-mc-sysfs-add-missing-mem-types.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:25 -0700
Message-ID: <200707192005.l6JK5PCp020044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36460 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760666AbXGSUPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: mc sysfs add missing mem types
has been removed from the -mm tree.  Its filename was
     drivers-edac-mc-sysfs-add-missing-mem-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: mc sysfs add missing mem types
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

origin.patch
