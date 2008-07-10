From: akpm@linux-foundation.org
Subject: + fix-name-of-russell-king-in-various-comments.patch added to -mm tree
Date: Wed, 09 Jul 2008 23:53:33 -0700
Message-ID: <200807100659.m6A6x0sF013596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbYGJG7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jul 2008 02:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, rmk+kernel@arm.linux.org.uk


The patch titled
     Fix name of Russell King in various comments
has been added to the -mm tree.  Its filename is
     fix-name-of-russell-king-in-various-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Fix name of Russell King in various comments
=46rom: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>

This patch was created by

	git grep -E -l 'Rus(el|s?e)l King' | xargs -r -t perl -p -i -e 's/Rus(=
el|s?e)l King/Russell King/g'

Signed-off-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Most-Definitely-Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci-au1xxx.c  |    2 +-
 drivers/usb/host/ohci-lh7a404.c |    2 +-
 drivers/usb/host/ohci-s3c2410.c |    2 +-
 drivers/usb/host/ohci-sa1111.c  |    2 +-
 include/asm-avr32/setup.h       |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/usb/host/ohci-au1xxx.c~fix-name-of-russell-king-in-va=
rious-comments drivers/usb/host/ohci-au1xxx.c
--- a/drivers/usb/host/ohci-au1xxx.c~fix-name-of-russell-king-in-variou=
s-comments
+++ a/drivers/usb/host/ohci-au1xxx.c
@@ -8,7 +8,7 @@
  * Bus Glue for AMD Alchemy Au1xxx
  *
  * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Rusell King et al.
+ * Based on fragments of previous driver by Russell King et al.
  *
  * Modified for LH7A404 from ohci-sa1111.c
  *  by Durgesh Pattamatta <pattamattad@sharpsec.com>
diff -puN drivers/usb/host/ohci-lh7a404.c~fix-name-of-russell-king-in-v=
arious-comments drivers/usb/host/ohci-lh7a404.c
--- a/drivers/usb/host/ohci-lh7a404.c~fix-name-of-russell-king-in-vario=
us-comments
+++ a/drivers/usb/host/ohci-lh7a404.c
@@ -8,7 +8,7 @@
  * Bus Glue for Sharp LH7A404
  *
  * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Rusell King et al.
+ * Based on fragments of previous driver by Russell King et al.
  *
  * Modified for LH7A404 from ohci-sa1111.c
  *  by Durgesh Pattamatta <pattamattad@sharpsec.com>
diff -puN drivers/usb/host/ohci-s3c2410.c~fix-name-of-russell-king-in-v=
arious-comments drivers/usb/host/ohci-s3c2410.c
--- a/drivers/usb/host/ohci-s3c2410.c~fix-name-of-russell-king-in-vario=
us-comments
+++ a/drivers/usb/host/ohci-s3c2410.c
@@ -8,7 +8,7 @@
  * USB Bus Glue for Samsung S3C2410
  *
  * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Rusell King et al.
+ * Based on fragments of previous driver by Russell King et al.
  *
  * Modified for S3C2410 from ohci-sa1111.c, ohci-omap.c and ohci-lh7a4=
0.c
  *	by Ben Dooks, <ben@simtec.co.uk>
diff -puN drivers/usb/host/ohci-sa1111.c~fix-name-of-russell-king-in-va=
rious-comments drivers/usb/host/ohci-sa1111.c
--- a/drivers/usb/host/ohci-sa1111.c~fix-name-of-russell-king-in-variou=
s-comments
+++ a/drivers/usb/host/ohci-sa1111.c
@@ -8,7 +8,7 @@
  * SA1111 Bus Glue
  *
  * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Rusell King et al.
+ * Based on fragments of previous driver by Russell King et al.
  *
  * This file is licenced under the GPL.
  */
diff -puN include/asm-avr32/setup.h~fix-name-of-russell-king-in-various=
-comments include/asm-avr32/setup.h
--- a/include/asm-avr32/setup.h~fix-name-of-russell-king-in-various-com=
ments
+++ a/include/asm-avr32/setup.h
@@ -2,7 +2,7 @@
  * Copyright (C) 2004-2006 Atmel Corporation
  *
  * Based on linux/include/asm-arm/setup.h
- *   Copyright (C) 1997-1999 Russel King
+ *   Copyright (C) 1997-1999 Russell King
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License version 2 as
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com=
 are

linux-next.patch
handle-failure-of-irqchip-set_type-in-setup_irq.patch
fix-name-of-russell-king-in-various-comments.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
