From: akpm@linux-foundation.org
Subject: + miguel-ojeda-has-moved.patch added to -mm tree
Date: Wed, 25 Jun 2008 16:25:33 -0700
Message-ID: <200806252325.m5PNPXk5032153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923AbYFYXZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 19:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miguel.ojeda.sandonis@gmail.com


The patch titled
     Miguel Ojeda has moved
has been added to the -mm tree.  Its filename is
     miguel-ojeda-has-moved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Miguel Ojeda has moved
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS                                       |    5 ++--
 Documentation/auxdisplay/cfag12864b           |    4 +--
 Documentation/auxdisplay/cfag12864b-example.c |    2 -
 Documentation/auxdisplay/ks0108               |    4 +--
 MAINTAINERS                                   |   20 +++++++++-------
 drivers/auxdisplay/Kconfig                    |    2 -
 drivers/auxdisplay/cfag12864b.c               |    4 +--
 drivers/auxdisplay/cfag12864bfb.c             |    4 +--
 drivers/auxdisplay/ks0108.c                   |    4 +--
 include/linux/cfag12864b.h                    |    2 -
 include/linux/ks0108.h                        |    2 -
 11 files changed, 29 insertions(+), 24 deletions(-)

diff -puN CREDITS~miguel-ojeda-has-moved CREDITS
--- a/CREDITS~miguel-ojeda-has-moved
+++ a/CREDITS
@@ -2611,8 +2611,9 @@ S: Perth, Western Australia
 S: Australia
 
 N: Miguel Ojeda Sandonis
-E: maxextreme@gmail.com
-W: http://maxextreme.googlepages.com/
+E: miguel.ojeda.sandonis@gmail.com
+W: http://miguelojeda.es
+W: http://jair.lab.fi.uva.es/~migojed/
 D: Author of the ks0108, cfag12864b and cfag12864bfb auxiliary display drivers.
 D: Maintainer of the auxiliary display drivers tree (drivers/auxdisplay/*)
 S: C/ Mieses 20, 9-B
diff -puN Documentation/auxdisplay/cfag12864b~miguel-ojeda-has-moved Documentation/auxdisplay/cfag12864b
--- a/Documentation/auxdisplay/cfag12864b~miguel-ojeda-has-moved
+++ a/Documentation/auxdisplay/cfag12864b
@@ -3,7 +3,7 @@
 	===================================
 
 License:		GPLv2
-Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
+Author & Maintainer:	Miguel Ojeda Sandonis
 Date:			2006-10-27
 
 
@@ -22,7 +22,7 @@ Date:			2006-10-27
 1. DRIVER INFORMATION
 ---------------------
 
-This driver support one cfag12864b display at time.
+This driver supports a cfag12864b LCD.
 
 
 ---------------------
diff -puN Documentation/auxdisplay/cfag12864b-example.c~miguel-ojeda-has-moved Documentation/auxdisplay/cfag12864b-example.c
--- a/Documentation/auxdisplay/cfag12864b-example.c~miguel-ojeda-has-moved
+++ a/Documentation/auxdisplay/cfag12864b-example.c
@@ -4,7 +4,7 @@
  * Description: cfag12864b LCD userspace example program
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
diff -puN Documentation/auxdisplay/ks0108~miguel-ojeda-has-moved Documentation/auxdisplay/ks0108
--- a/Documentation/auxdisplay/ks0108~miguel-ojeda-has-moved
+++ a/Documentation/auxdisplay/ks0108
@@ -3,7 +3,7 @@
 	==========================================
 
 License:		GPLv2
-Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
+Author & Maintainer:	Miguel Ojeda Sandonis
 Date:			2006-10-27
 
 
@@ -21,7 +21,7 @@ Date:			2006-10-27
 1. DRIVER INFORMATION
 ---------------------
 
-This driver support the ks0108 LCD controller.
+This driver supports the ks0108 LCD controller.
 
 
 ---------------------
diff -puN MAINTAINERS~miguel-ojeda-has-moved MAINTAINERS
--- a/MAINTAINERS~miguel-ojeda-has-moved
+++ a/MAINTAINERS
@@ -763,9 +763,10 @@ S:	Maintained
 
 AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://miguelojeda.es/auxdisplay.htm
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 AVR32 ARCHITECTURE
@@ -1055,16 +1056,18 @@ S:	Supported
 
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://miguelojeda.es/auxdisplay.htm
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://miguelojeda.es/auxdisplay.htm
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 CFG80211 and NL80211
@@ -2428,9 +2431,10 @@ S:	Maintained
 
 KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://miguelojeda.es/auxdisplay.htm
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 LAPB module
diff -puN drivers/auxdisplay/Kconfig~miguel-ojeda-has-moved drivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~miguel-ojeda-has-moved
+++ a/drivers/auxdisplay/Kconfig
@@ -64,7 +64,7 @@ config KS0108_DELAY
 	  Amount of time the ks0108 should wait between each control write
 	  to the parallel port.
 
-	  If your driver seems to miss random writings, increment this.
+	  If your LCD seems to miss random writings, increment this.
 
 	  If you don't know what I'm talking about, ignore it.
 
diff -puN drivers/auxdisplay/cfag12864b.c~miguel-ojeda-has-moved drivers/auxdisplay/cfag12864b.c
--- a/drivers/auxdisplay/cfag12864b.c~miguel-ojeda-has-moved
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -5,7 +5,7 @@
  *     License: GPLv2
  *     Depends: ks0108
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -398,5 +398,5 @@ module_init(cfag12864b_init);
 module_exit(cfag12864b_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("cfag12864b LCD driver");
diff -puN drivers/auxdisplay/cfag12864bfb.c~miguel-ojeda-has-moved drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~miguel-ojeda-has-moved
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -5,7 +5,7 @@
  *     License: GPLv2
  *     Depends: cfag12864b
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -186,5 +186,5 @@ module_init(cfag12864bfb_init);
 module_exit(cfag12864bfb_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("cfag12864b LCD framebuffer driver");
diff -puN drivers/auxdisplay/ks0108.c~miguel-ojeda-has-moved drivers/auxdisplay/ks0108.c
--- a/drivers/auxdisplay/ks0108.c~miguel-ojeda-has-moved
+++ a/drivers/auxdisplay/ks0108.c
@@ -5,7 +5,7 @@
  *     License: GPLv2
  *     Depends: parport
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -173,6 +173,6 @@ module_init(ks0108_init);
 module_exit(ks0108_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("ks0108 LCD Controller driver");
 
diff -puN include/linux/cfag12864b.h~miguel-ojeda-has-moved include/linux/cfag12864b.h
--- a/include/linux/cfag12864b.h~miguel-ojeda-has-moved
+++ a/include/linux/cfag12864b.h
@@ -4,7 +4,7 @@
  * Description: cfag12864b LCD driver header
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-12
  *
  *  This program is free software; you can redistribute it and/or modify
diff -puN include/linux/ks0108.h~miguel-ojeda-has-moved include/linux/ks0108.h
--- a/include/linux/ks0108.h~miguel-ojeda-has-moved
+++ a/include/linux/ks0108.h
@@ -4,7 +4,7 @@
  * Description: ks0108 LCD Controller driver header
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
_

Patches currently in -mm which might be from miguel.ojeda.sandonis@gmail.com are

miguel-ojeda-has-moved.patch

