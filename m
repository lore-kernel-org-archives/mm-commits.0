From: akpm@linux-foundation.org
Subject: - dockc-remove-trailing-printk-whitespace.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:37 -0700
Message-ID: <200806122036.m5CKabVF005345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618AbYFLUg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     dock.c remove trailing printk whitespace
has been removed from the -mm tree.  Its filename was
     dockc-remove-trailing-printk-whitespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dock.c remove trailing printk whitespace
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/dock.c~dockc-remove-trailing-printk-whitespace drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~dockc-remove-trailing-printk-whitespace
+++ a/drivers/acpi/dock.c
@@ -834,7 +834,7 @@ static int dock_add(acpi_handle handle)
 		goto dock_add_err;
 	}
 
-	printk(KERN_INFO PREFIX "%s \n", ACPI_DOCK_DRIVER_DESCRIPTION);
+	printk(KERN_INFO PREFIX "%s\n", ACPI_DOCK_DRIVER_DESCRIPTION);
 
 	return 0;
 
_

Patches currently in -mm which might be from lnxninja@linux.vnet.ibm.com are

origin.patch

