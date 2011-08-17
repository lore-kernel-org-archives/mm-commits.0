From: akpm@linux-foundation.org
Subject: + maintainers-evgeniy-has-moved.patch added to -mm tree
Date: Wed, 17 Aug 2011 12:23:54 -0700
Message-ID: <201108171923.p7HJNsi1022927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab1HQTY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 15:24:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbr@ioremap.net


The patch titled
     MAINTAINERS: Evgeniy has moved
has been added to the -mm tree.  Its filename is
     maintainers-evgeniy-has-moved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: Evgeniy has moved
From: Evgeniy Polyakov <zbr@ioremap.net>

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                    |    2 +-
 drivers/w1/masters/ds2490.c    |    4 ++--
 drivers/w1/masters/matrox_w1.c |    4 ++--
 drivers/w1/slaves/w1_smem.c    |    4 ++--
 drivers/w1/slaves/w1_therm.c   |    4 ++--
 drivers/w1/w1.c                |    4 ++--
 drivers/w1/w1.h                |    2 +-
 drivers/w1/w1_family.c         |    2 +-
 drivers/w1/w1_family.h         |    2 +-
 drivers/w1/w1_int.c            |    2 +-
 drivers/w1/w1_int.h            |    2 +-
 drivers/w1/w1_io.c             |    2 +-
 drivers/w1/w1_log.h            |    2 +-
 drivers/w1/w1_netlink.c        |    2 +-
 drivers/w1/w1_netlink.h        |    2 +-
 include/linux/connector.h      |    2 +-
 16 files changed, 21 insertions(+), 21 deletions(-)

diff -puN MAINTAINERS~maintainers-evgeniy-has-moved MAINTAINERS
--- a/MAINTAINERS~maintainers-evgeniy-has-moved
+++ a/MAINTAINERS
@@ -7087,7 +7087,7 @@ S:	Supported
 F:	drivers/mmc/host/vub300.c
 
 W1 DALLAS'S 1-WIRE BUS
-M:	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+M:	Evgeniy Polyakov <zbr@ioremap.net>
 S:	Maintained
 F:	Documentation/w1/
 F:	drivers/w1/
diff -puN drivers/w1/masters/ds2490.c~maintainers-evgeniy-has-moved drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/masters/ds2490.c
@@ -1,7 +1,7 @@
 /*
  *	dscore.c
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
@@ -1024,5 +1024,5 @@ module_init(ds_init);
 module_exit(ds_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
+MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("DS2490 USB <-> W1 bus master driver (DS9490*)");
diff -puN drivers/w1/masters/matrox_w1.c~maintainers-evgeniy-has-moved drivers/w1/masters/matrox_w1.c
--- a/drivers/w1/masters/matrox_w1.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/masters/matrox_w1.c
@@ -1,7 +1,7 @@
 /*
  *	matrox_w1.c
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
@@ -39,7 +39,7 @@
 #include "../w1_log.h"
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
+MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for transport(Dallas 1-wire prtocol) over VGA DDC(matrox gpio).");
 
 static struct pci_device_id matrox_w1_tbl[] = {
diff -puN drivers/w1/slaves/w1_smem.c~maintainers-evgeniy-has-moved drivers/w1/slaves/w1_smem.c
--- a/drivers/w1/slaves/w1_smem.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/slaves/w1_smem.c
@@ -1,7 +1,7 @@
 /*
  *	w1_smem.c
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
@@ -32,7 +32,7 @@
 #include "../w1_family.h"
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
+MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, 64bit memory family.");
 
 static struct w1_family w1_smem_family_01 = {
diff -puN drivers/w1/slaves/w1_therm.c~maintainers-evgeniy-has-moved drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/slaves/w1_therm.c
@@ -1,7 +1,7 @@
 /*
  *	w1_therm.c
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
@@ -34,7 +34,7 @@
 #include "../w1_family.h"
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
+MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, temperature family.");
 
 /* Allow the strong pullup to be disabled, but default to enabled.
diff -puN drivers/w1/w1.c~maintainers-evgeniy-has-moved drivers/w1/w1.c
--- a/drivers/w1/w1.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1.c
@@ -1,7 +1,7 @@
 /*
  *	w1.c
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
@@ -42,7 +42,7 @@
 #include "w1_netlink.h"
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
+MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol.");
 
 static int w1_timeout = 10;
diff -puN drivers/w1/w1.h~maintainers-evgeniy-has-moved drivers/w1/w1.h
--- a/drivers/w1/w1.h~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1.h
@@ -1,7 +1,7 @@
 /*
  *	w1.h
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/w1/w1_family.c~maintainers-evgeniy-has-moved drivers/w1/w1_family.c
--- a/drivers/w1/w1_family.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1_family.c
@@ -1,7 +1,7 @@
 /*
  *	w1_family.c
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/w1/w1_family.h~maintainers-evgeniy-has-moved drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1_family.h
@@ -1,7 +1,7 @@
 /*
  *	w1_family.h
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/w1/w1_int.c~maintainers-evgeniy-has-moved drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1_int.c
@@ -1,7 +1,7 @@
 /*
  *	w1_int.c
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/w1/w1_int.h~maintainers-evgeniy-has-moved drivers/w1/w1_int.h
--- a/drivers/w1/w1_int.h~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1_int.h
@@ -1,7 +1,7 @@
 /*
  *	w1_int.h
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/w1/w1_io.c~maintainers-evgeniy-has-moved drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1_io.c
@@ -1,7 +1,7 @@
 /*
  *	w1_io.c
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/w1/w1_log.h~maintainers-evgeniy-has-moved drivers/w1/w1_log.h
--- a/drivers/w1/w1_log.h~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1_log.h
@@ -1,7 +1,7 @@
 /*
  *	w1_log.h
  *
- * Copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/w1/w1_netlink.c~maintainers-evgeniy-has-moved drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1_netlink.c
@@ -1,7 +1,7 @@
 /*
  * w1_netlink.c
  *
- * Copyright (c) 2003 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2003 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/w1/w1_netlink.h~maintainers-evgeniy-has-moved drivers/w1/w1_netlink.h
--- a/drivers/w1/w1_netlink.h~maintainers-evgeniy-has-moved
+++ a/drivers/w1/w1_netlink.h
@@ -1,7 +1,7 @@
 /*
  * w1_netlink.h
  *
- * Copyright (c) 2003 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * Copyright (c) 2003 Evgeniy Polyakov <zbr@ioremap.net>
  *
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN include/linux/connector.h~maintainers-evgeniy-has-moved include/linux/connector.h
--- a/include/linux/connector.h~maintainers-evgeniy-has-moved
+++ a/include/linux/connector.h
@@ -1,7 +1,7 @@
 /*
  * 	connector.h
  * 
- * 2004-2005 Copyright (c) Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * 2004-2005 Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
  * All rights reserved.
  * 
  * This program is free software; you can redistribute it and/or modify
_

Patches currently in -mm which might be from zbr@ioremap.net are

w1-fix-for-loop-in-w1_f29_remove_slave.patch
maintainers-evgeniy-has-moved.patch
hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch

