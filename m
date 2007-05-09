From: akpm@linux-foundation.org
Subject: - serial_txx9-zap-changelog-from-source-code.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:44 -0700
Message-ID: <200705090250.l492oiwT009384@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970030AbXEICuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial_txx9: zap changelog from source code
has been removed from the -mm tree.  Its filename was
     serial_txx9-zap-changelog-from-source-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial_txx9: zap changelog from source code
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-zap-changelog-from-source-code drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-zap-changelog-from-source-code
+++ a/drivers/serial/serial_txx9.c
@@ -15,31 +15,6 @@
  * published by the Free Software Foundation.
  *
  *  Serial driver for TX3927/TX4927/TX4925/TX4938 internal SIO controller
- *
- *  Revision History:
- *	0.30	Initial revision. (Renamed from serial_txx927.c)
- *	0.31	Use save_flags instead of local_irq_save.
- *	0.32	Support SCLK.
- *	0.33	Switch TXX9_TTY_NAME by CONFIG_SERIAL_TXX9_STDSERIAL.
- *		Support TIOCSERGETLSR.
- *	0.34	Support slow baudrate.
- *	0.40	Merge codes from mainstream kernel (2.4.22).
- *	0.41	Fix console checking in rs_shutdown_port().
- *		Disable flow-control in serial_console_write().
- *	0.42	Fix minor compiler warning.
- *	1.00	Kernel 2.6.  Converted to new serial core (based on 8250.c).
- *	1.01	Set fifosize to make tx_empry called properly.
- *		Use standard uart_get_divisor.
- *	1.02	Cleanup. (import 8250.c changes)
- *	1.03	Fix low-latency mode. (import 8250.c changes)
- *	1.04	Remove usage of deprecated functions, cleanup.
- *	1.05	More strict check in verify_port.  Cleanup.
- *	1.06	Do not insert a char caused previous overrun.
- *		Fix some spin_locks.
- *		Do not call uart_add_one_port for absent ports.
- *	1.07	Use CONFIG_SERIAL_TXX9_NR_UARTS.  Cleanup.
- *	1.08	Use platform_device.
- *		Fix and cleanup suspend/resume/initialization codes.
  */
 
 #if defined(CONFIG_SERIAL_TXX9_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
