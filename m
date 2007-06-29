From: akpm@linux-foundation.org
Subject: - add-some-pci-ids-for-xgi-chips.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:03 -0700
Message-ID: <200706292041.l5TKf3R7022547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133AbXF2Uun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: idr@us.ibm.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: add some pci ids for XGI chips
has been removed from the -mm tree.  Its filename was
     add-some-pci-ids-for-xgi-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drm: add some pci ids for XGI chips
From: Ian Romanick <idr@us.ibm.com>

This adds support for some of the XGI Volari family that are based on the SiS.

Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_pciids.h |    2 ++
 drivers/char/drm/sis_drv.h    |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/char/drm/drm_pciids.h~add-some-pci-ids-for-xgi-chips drivers/char/drm/drm_pciids.h
--- a/drivers/char/drm/drm_pciids.h~add-some-pci-ids-for-xgi-chips
+++ a/drivers/char/drm/drm_pciids.h
@@ -219,6 +219,8 @@
 	{0x1039, 0x6300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1039, 0x6330, PCI_ANY_ID, PCI_ANY_ID, 0, 0, SIS_CHIP_315}, \
 	{0x1039, 0x7300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
+	{0x18CA, 0x0040, PCI_ANY_ID, PCI_ANY_ID, 0, 0, SIS_CHIP_315}, \
+	{0x18CA, 0x0042, PCI_ANY_ID, PCI_ANY_ID, 0, 0, SIS_CHIP_315}, \
 	{0, 0, 0}
 
 #define tdfx_PCI_IDS \
diff -puN drivers/char/drm/sis_drv.h~add-some-pci-ids-for-xgi-chips drivers/char/drm/sis_drv.h
--- a/drivers/char/drm/sis_drv.h~add-some-pci-ids-for-xgi-chips
+++ a/drivers/char/drm/sis_drv.h
@@ -33,11 +33,11 @@
 
 #define DRIVER_AUTHOR		"SIS, Tungsten Graphics"
 #define DRIVER_NAME		"sis"
-#define DRIVER_DESC		"SIS 300/630/540"
-#define DRIVER_DATE		"20060704"
+#define DRIVER_DESC		"SIS 300/630/540 and XGI V3XE/V5/V8"
+#define DRIVER_DATE		"20070626"
 #define DRIVER_MAJOR		1
-#define DRIVER_MINOR		2
-#define DRIVER_PATCHLEVEL	1
+#define DRIVER_MINOR		3
+#define DRIVER_PATCHLEVEL	0
 
 enum sis_family {
 	SIS_OTHER = 0,
_

Patches currently in -mm which might be from idr@us.ibm.com are

origin.patch
