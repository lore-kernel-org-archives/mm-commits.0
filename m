From: akpm@linux-foundation.org
Subject: - serial_txx9-cleanup-includes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:54 -0700
Message-ID: <200710162029.l9GKTsJK014349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936004AbXJPUaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, alan@lxorguk.ukuu.org.uk, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial_txx9: cleanup includes
has been removed from the -mm tree.  Its filename was
     serial_txx9-cleanup-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial_txx9: cleanup includes
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Do not include some header files already indluded by serial_core.h.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |    4 ----
 1 file changed, 4 deletions(-)

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
