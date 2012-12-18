From: akpm@linux-foundation.org
Subject: [merged] corentin-has-moved.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:41 -0800
Message-ID: <20121218200342.0C35920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:61482 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:44 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so63197bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corentin.chary@gmail.com, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Corentin has moved
has been removed from the -mm tree.  Its filename was
     corentin-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Corentin Chary <corentin.chary@gmail.com>
Subject: Corentin has moved

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                        |    4 ++--
 drivers/platform/x86/asus-nb-wmi.c |    2 +-
 drivers/platform/x86/asus-wmi.c    |    2 +-
 drivers/platform/x86/eeepc-wmi.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~corentin-has-moved MAINTAINERS
--- a/MAINTAINERS~corentin-has-moved
+++ a/MAINTAINERS
@@ -1280,7 +1280,7 @@ F:	Documentation/hwmon/asc7621
 F:	drivers/hwmon/asc7621.c
 
 ASUS NOTEBOOKS AND EEEPC ACPI/WMI EXTRAS DRIVERS
-M:	Corentin Chary <corentincj@iksaif.net>
+M:	Corentin Chary <corentin.chary@gmail.com>
 L:	acpi4asus-user@lists.sourceforge.net
 L:	platform-driver-x86@vger.kernel.org
 W:	http://acpi4asus.sf.net
@@ -6490,7 +6490,7 @@ F:	drivers/media/pci/saa7146/
 F:	include/media/saa7146*
 
 SAMSUNG LAPTOP DRIVER
-M:	Corentin Chary <corentincj@iksaif.net>
+M:	Corentin Chary <corentin.chary@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/samsung-laptop.c
diff -puN drivers/platform/x86/asus-nb-wmi.c~corentin-has-moved drivers/platform/x86/asus-nb-wmi.c
--- a/drivers/platform/x86/asus-nb-wmi.c~corentin-has-moved
+++ a/drivers/platform/x86/asus-nb-wmi.c
@@ -32,7 +32,7 @@
 
 #define	ASUS_NB_WMI_FILE	"asus-nb-wmi"
 
-MODULE_AUTHOR("Corentin Chary <corentincj@iksaif.net>");
+MODULE_AUTHOR("Corentin Chary <corentin.chary@gmail.com>");
 MODULE_DESCRIPTION("Asus Notebooks WMI Hotkey Driver");
 MODULE_LICENSE("GPL");
 
diff -puN drivers/platform/x86/asus-wmi.c~corentin-has-moved drivers/platform/x86/asus-wmi.c
--- a/drivers/platform/x86/asus-wmi.c~corentin-has-moved
+++ a/drivers/platform/x86/asus-wmi.c
@@ -51,7 +51,7 @@
 
 #include "asus-wmi.h"
 
-MODULE_AUTHOR("Corentin Chary <corentincj@iksaif.net>, "
+MODULE_AUTHOR("Corentin Chary <corentin.chary@gmail.com>, "
 	      "Yong Wang <yong.y.wang@intel.com>");
 MODULE_DESCRIPTION("Asus Generic WMI Driver");
 MODULE_LICENSE("GPL");
diff -puN drivers/platform/x86/eeepc-wmi.c~corentin-has-moved drivers/platform/x86/eeepc-wmi.c
--- a/drivers/platform/x86/eeepc-wmi.c~corentin-has-moved
+++ a/drivers/platform/x86/eeepc-wmi.c
@@ -39,7 +39,7 @@
 
 #define	EEEPC_WMI_FILE	"eeepc-wmi"
 
-MODULE_AUTHOR("Corentin Chary <corentincj@iksaif.net>");
+MODULE_AUTHOR("Corentin Chary <corentin.chary@gmail.com>");
 MODULE_DESCRIPTION("Eee PC WMI Hotkey Driver");
 MODULE_LICENSE("GPL");
 
_

Patches currently in -mm which might be from corentin.chary@gmail.com are

origin.patch
linux-next.patch

