From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-i5000.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:16 -0700
Message-ID: <200707192006.l6JK6GmK020122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761458AbXGSUQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, djiang@mvista.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent i5000
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-i5000.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent i5000
From: Douglas Thompson <dougthompson@xmission.com>

Ran e752x_edac.c file through Lindent for cleanup

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/edac/i5000_edac.c~drivers-edac-lindent-i5000 drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-lindent-i5000
+++ a/drivers/edac/i5000_edac.c
@@ -967,7 +967,7 @@ static void calculate_dimm_size(struct i
 	mem_buffer = p = kmalloc(space, GFP_KERNEL);
 	if (p == NULL) {
 		i5000_printk(KERN_ERR, "MC: %s:%s() kmalloc() failed\n",
-			    __FILE__, __func__);
+			     __FILE__, __func__);
 		return;
 	}
 
@@ -1287,13 +1287,13 @@ static int i5000_probe1(struct pci_dev *
 		return -ENODEV;
 
 	/* make sure error reporting method is sane */
-	switch(edac_op_state) {
-		case EDAC_OPSTATE_POLL:
-		case EDAC_OPSTATE_NMI:
-			break;
-		default:
-			edac_op_state = EDAC_OPSTATE_POLL;
-			break;
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_NMI:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_POLL;
+		break;
 	}
 
 	/* Ask the devices for the number of CSROWS and CHANNELS so
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
