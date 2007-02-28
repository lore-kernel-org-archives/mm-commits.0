From: akpm@linux-foundation.org
Subject: - serial-serial_txx9-driver-update-3.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:42 -0800
Message-ID: <200702282353.l1SNrgU2031138@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48427 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbXB1Xx4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:53:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     serial: serial_txx9 driver update (take 2) (3, actually)
has been removed from the -mm tree.  Its filename was
     serial-serial_txx9-driver-update-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

8139too-fix-irq-problem-with-napi-netpoll.patch
x86_64-fix-section-mismatch-warnings.patch
