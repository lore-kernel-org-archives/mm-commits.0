From: akpm@linux-foundation.org
Subject: - claim-maintainership-for-block2mtd-and-update-email-addresses.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:21 -0800
Message-ID: <200802070025.m170P2Vs006683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934008AbYBGApw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joern@lazybastard.org, apw@shadowen.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Claim maintainership for block2mtd and update email addresses
has been removed from the -mm tree.  Its filename was
     claim-maintainership-for-block2mtd-and-update-email-addresses.patc=
h

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Claim maintainership for block2mtd and update email addresses
=46rom: Joern Engel <joern@lazybastard.org>

I have been prime author and maintainer of block2mtd from day one, but
neither MAINTAINERS nor the module source makes this fact clear.  And w=
hile
I'm at it, update my email addresses tree-wide, as the old address
currently bounces and change my name to "joern" as unicode will likely
continue to cause trouble until the end of this century.

Signed-off-by: Joern Engel <joern@lazybastard.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                     |   10 ++++++++--
 drivers/mtd/devices/block2mtd.c |    4 ++--
 drivers/mtd/devices/phram.c     |    4 ++--
 drivers/mtd/maps/mtx-1_flash.c  |    2 +-
 scripts/checkstack.pl           |    2 +-
 5 files changed, 14 insertions(+), 8 deletions(-)

diff -puN MAINTAINERS~claim-maintainership-for-block2mtd-and-update-ema=
il-addresses MAINTAINERS
--- a/MAINTAINERS~claim-maintainership-for-block2mtd-and-update-email-a=
ddresses
+++ a/MAINTAINERS
@@ -840,6 +840,12 @@ L:	linux-kernel@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
=20
+BLOCK2MTD DRIVER
+P:	Joern Engel
+M:	joern@lazybastard.org
+L:	linux-mtd@lists.infradead.org
+S:	Maintained
+
 BLUETOOTH SUBSYSTEM
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
@@ -3030,8 +3036,8 @@ L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
=20
 PHRAM MTD DRIVER
-P:	J=C3=B6rn Engel
-M:	joern@wh.fh-wedel.de
+P:	Joern Engel
+M:	joern@lazybastard.org
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
=20
diff -puN drivers/mtd/devices/block2mtd.c~claim-maintainership-for-bloc=
k2mtd-and-update-email-addresses drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~claim-maintainership-for-block2mt=
d-and-update-email-addresses
+++ a/drivers/mtd/devices/block2mtd.c
@@ -4,7 +4,7 @@
  * block2mtd.c - create an mtd from a block device
  *
  * Copyright (C) 2001,2002	Simon Evans <spse@secret.org.uk>
- * Copyright (C) 2004-2006	J=C3=B6rn Engel <joern@wh.fh-wedel.de>
+ * Copyright (C) 2004-2006	Joern Engel <joern@wh.fh-wedel.de>
  *
  * Licence: GPL
  */
@@ -485,5 +485,5 @@ module_init(block2mtd_init);
 module_exit(block2mtd_exit);
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Simon Evans <spse@secret.org.uk> and others");
+MODULE_AUTHOR("Joern Engel <joern@lazybastard.org>");
 MODULE_DESCRIPTION("Emulate an MTD using a block device");
diff -puN drivers/mtd/devices/phram.c~claim-maintainership-for-block2mt=
d-and-update-email-addresses drivers/mtd/devices/phram.c
--- a/drivers/mtd/devices/phram.c~claim-maintainership-for-block2mtd-an=
d-update-email-addresses
+++ a/drivers/mtd/devices/phram.c
@@ -2,7 +2,7 @@
  * $Id: phram.c,v 1.16 2005/11/07 11:14:25 gleixner Exp $
  *
  * Copyright (c) ????		Jochen Sch=C3=A4uble <psionic@psionic.de>
- * Copyright (c) 2003-2004	J=C3=B6rn Engel <joern@wh.fh-wedel.de>
+ * Copyright (c) 2003-2004	Joern Engel <joern@wh.fh-wedel.de>
  *
  * Usage:
  *
@@ -299,5 +299,5 @@ module_init(init_phram);
 module_exit(cleanup_phram);
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("J=C3=B6rn Engel <joern@wh.fh-wedel.de>");
+MODULE_AUTHOR("Joern Engel <joern@wh.fh-wedel.de>");
 MODULE_DESCRIPTION("MTD driver for physical RAM");
diff -puN drivers/mtd/maps/mtx-1_flash.c~claim-maintainership-for-block=
2mtd-and-update-email-addresses drivers/mtd/maps/mtx-1_flash.c
--- a/drivers/mtd/maps/mtx-1_flash.c~claim-maintainership-for-block2mtd=
-and-update-email-addresses
+++ a/drivers/mtd/maps/mtx-1_flash.c
@@ -4,7 +4,7 @@
  * $Id: mtx-1_flash.c,v 1.2 2005/11/07 11:14:27 gleixner Exp $
  *
  * (C) 2005 Bruno Randolf <bruno.randolf@4g-systems.biz>
- * (C) 2005 J=C3=B6rn Engel <joern@wohnheim.fh-wedel.de>
+ * (C) 2005 Joern Engel <joern@wohnheim.fh-wedel.de>
  *
  */
=20
diff -puN scripts/checkstack.pl~claim-maintainership-for-block2mtd-and-=
update-email-addresses scripts/checkstack.pl
--- a/scripts/checkstack.pl~claim-maintainership-for-block2mtd-and-upda=
te-email-addresses
+++ a/scripts/checkstack.pl
@@ -2,7 +2,7 @@
=20
 #	Check the stack usage of functions
 #
-#	Copyright Joern Engel <joern@wh.fh-wedel.de>
+#	Copyright Joern Engel <joern@lazybastard.org>
 #	Inspired by Linus Torvalds
 #	Original idea maybe from Keith Owens
 #	s390 port and big speedup by Arnd Bergmann <arnd@bergmann-dalldorf.d=
e>
_

Patches currently in -mm which might be from joern@lazybastard.org are

origin.patch
