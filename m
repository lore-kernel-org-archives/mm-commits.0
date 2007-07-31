From: akpm@linux-foundation.org
Subject: - serial-mpsc-remove-duplicate-support_sysrq-definition.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:51 -0700
Message-ID: <200707312357.l6VNvpbe029434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753034AbXHAAJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgreer@mvista.com, mm-commits@vger.kernel.org


The patch titled
     serial: MPSC: Remove duplicate SUPPORT_SYSRQ definition
has been removed from the -mm tree.  Its filename was
     serial-mpsc-remove-duplicate-support_sysrq-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: MPSC: Remove duplicate SUPPORT_SYSRQ definition
From: "Mark A. Greer" <mgreer@mvista.com>

Remove the duplicate definition of SUPPORT_SYSRQ in mpsc driver.

Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/serial/mpsc.c~serial-mpsc-remove-duplicate-support_sysrq-definition drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~serial-mpsc-remove-duplicate-support_sysrq-definition
+++ a/drivers/serial/mpsc.c
@@ -74,10 +74,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#if defined(CONFIG_SERIAL_MPSC_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
-#define SUPPORT_SYSRQ
-#endif
-
 #define	MPSC_NUM_CTLRS		2
 
 /*
_

Patches currently in -mm which might be from mgreer@mvista.com are

origin.patch
