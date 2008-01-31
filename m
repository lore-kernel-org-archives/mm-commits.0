From: akpm@linux-foundation.org
Subject: + spi_bfin-headers-are-not-for-changelogs.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:27:06 -0800
Message-ID: <200801312127.m0VLR6pm012162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753241AbYAaV1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:27:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.frysinger@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi_bfin: headers are not for changelogs
has been added to the -mm tree.  Its filename is
     spi_bfin-headers-are-not-for-changelogs.patch

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
Subject: spi_bfin: headers are not for changelogs
From: Mike Frysinger <michael.frysinger@analog.com>

Use simpler comment headers, and strip out information that is maintained in
GIT history

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   32 +++-----------------------------
 1 file changed, 3 insertions(+), 29 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin-headers-are-not-for-changelogs drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin-headers-are-not-for-changelogs
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1,37 +1,11 @@
 /*
- * File:	drivers/spi/bfin5xx_spi.c
- * Maintainer:
- *		Bryan Wu <bryan.wu@analog.com>
- * Original Author:
- *		Luke Yang (Analog Devices Inc.)
- *
- * Created:	March. 10th 2006
- * Description:	SPI controller driver for Blackfin BF5xx
- * Bugs:	Enter bugs at http://blackfin.uclinux.org/
- *
- * Modified:
- *	March 10, 2006  bfin5xx_spi.c Created. (Luke Yang)
- *      August 7, 2006  added full duplex mode (Axel Weiss & Luke Yang)
- *      July  17, 2007  add support for BF54x SPI0 controller (Bryan Wu)
- *      July  30, 2007  add platfrom_resource interface to support multi-port
- *                      SPI controller (Bryan Wu)
+ * Blackfin On-Chip SPI Driver
  *
  * Copyright 2004-2007 Analog Devices Inc.
  *
- * This program is free software ;  you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation ;  either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY ;  without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * Enter bugs at http://blackfin.uclinux.org/
  *
- * You should have received a copy of the GNU General Public License
- * along with this program ;  see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Licensed under the GPL-2 or later.
  */
 
 #include <linux/init.h>
_

Patches currently in -mm which might be from michael.frysinger@analog.com are

origin.patch
spi_bfin-headers-are-not-for-changelogs.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
