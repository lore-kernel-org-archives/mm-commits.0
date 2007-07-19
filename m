From: akpm@linux-foundation.org
Subject: + serial-mpsc-remove-duplicate-support_sysrq-definition.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:41:24 -0700
Message-ID: <200707192141.l6JLfOCr024471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759885AbXGSVmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgreer@mvista.com


The patch titled
     serial: MPSC: Remove duplicate SUPPORT_SYSRQ definition
has been added to the -mm tree.  Its filename is
     serial-mpsc-remove-duplicate-support_sysrq-definition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: MPSC: Remove duplicate SUPPORT_SYSRQ definition
From: "Mark A. Greer" <mgreer@mvista.com>

Remove the duplicate definition of SUPPORT_SYSRQ in mpsc driver.

Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |    4 ----
 1 files changed, 4 deletions(-)

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
serial-mpsc-remove-race-between-rx-stop-restart.patch
serial-mpsc-stop-rx-engine-when-cread-cleared.patch
serial-mpsc-remove-duplicate-support_sysrq-definition.patch
serial-mpsc-fix-coding-style-and-whitespace-issues.patch
