From: akpm@linux-foundation.org
Subject: + serial-serial_txx9-driver-update-3.patch added to -mm tree
Date: Wed, 21 Feb 2007 17:13:50 -0800
Message-ID: <200702220113.l1M1DoHQ032549@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422851AbXBVBOA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 20:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, alan@redhat.com


The patch titled
     serial: serial_txx9 driver update (take 2) (3, actually)
has been added to the -mm tree.  Its filename is
     serial-serial_txx9-driver-update-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: serial_txx9 driver update (take 2) (3, actually)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Update the serial_txx9 driver.

 * Use platform_device.
 * Fix and cleanup suspend/resume/initialization codes.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/serial_txx9.c~serial-serial_txx9-driver-update-3 drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial-serial_txx9-driver-update-3
+++ a/drivers/serial/serial_txx9.c
@@ -39,7 +39,7 @@
  *		Do not call uart_add_one_port for absent ports.
  *	1.07	Use CONFIG_SERIAL_TXX9_NR_UARTS.  Cleanup.
  *	1.08	Use platform_device.
- *		Fix and cleanup suspend/resume codes.
+ *		Fix and cleanup suspend/resume/initialization codes.
  */
 
 #if defined(CONFIG_SERIAL_TXX9_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-mips.patch
serial-serial_txx9-driver-update.patch
serial-serial_txx9-driver-update-fix.patch
serial-serial_txx9-driver-update-3.patch
