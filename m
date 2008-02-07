From: akpm@linux-foundation.org
Subject: - spi_bfin-headers-are-not-for-changelogs.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:10 -0800
Message-ID: <200802070025.m170Pp5U006755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933962AbYBGAp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.frysinger@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bfin: headers are not for changelogs
has been removed from the -mm tree.  Its filename was
     spi_bfin-headers-are-not-for-changelogs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-watchdog.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
