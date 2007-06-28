From: akpm@linux-foundation.org
Subject: + serial_txx9-cleanup-includes.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:14:09 -0700
Message-ID: <200706282214.l5SME9Aj002678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763343AbXF1WO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, ralf@linux-mips.org


The patch titled
     serial_txx9: cleanup includes
has been added to the -mm tree.  Its filename is
     serial_txx9-cleanup-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial_txx9: cleanup includes
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Do not include some header files already indluded by serial_core.h.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-cleanup-includes drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-cleanup-includes
+++ a/drivers/serial/serial_txx9.c
@@ -25,15 +25,11 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/console.h>
-#include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
-#include <linux/tty.h>
-#include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
-#include <linux/mutex.h>
 
 #include <asm/io.h>
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-kbuild.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
