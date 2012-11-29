From: akpm@linux-foundation.org
Subject: + corentin-has-moved.patch added to -mm tree
Date: Thu, 29 Nov 2012 15:40:33 -0800
Message-ID: <20121129234034.09A2620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36791 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K2Xkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Nov 2012 18:40:36 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so1725lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Nov 2012 15:40:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corentin.chary@gmail.com, mjg59@srcf.ucam.org


The patch titled
     Subject: Corentin has moved
has been added to the -mm tree.  Its filename is
     corentin-has-moved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1278,7 +1278,7 @@ F:	Documentation/hwmon/asc7621
 F:	drivers/hwmon/asc7621.c
 
 ASUS NOTEBOOKS AND EEEPC ACPI/WMI EXTRAS DRIVERS
-M:	Corentin Chary <corentincj@iksaif.net>
+M:	Corentin Chary <corentin.chary@gmail.com>
 L:	acpi4asus-user@lists.sourceforge.net
 L:	platform-driver-x86@vger.kernel.org
 W:	http://acpi4asus.sf.net
@@ -6469,7 +6469,7 @@ F:	drivers/media/pci/saa7146/
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

linux-next.patch
corentin-has-moved.patch

