From: akpm@linux-foundation.org
Subject: - mpc52xx-psc-spi-master-driver-update-tidy.patch removed from -mm tree
Date: Thu, 10 May 2007 21:50:33 -0700
Message-ID: <200705110450.l4B4oXoK006391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbXEKEv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 00:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, dragos.carp@toptica.com, mm-commits@vger.kernel.org


The patch titled
     mpc52xx-psc-spi-master-driver-update-tidy
has been removed from the -mm tree.  Its filename was
     mpc52xx-psc-spi-master-driver-update-tidy.patch

This patch was dropped because it was folded into mpc52xx-psc-spi-master-driver.patch

------------------------------------------------------
Subject: mpc52xx-psc-spi-master-driver-update-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Brownell <david-b@pacbell.net>
Cc: Dragos Carp <dragos.carp@toptica.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc52xx-psc-spi-master-driver-update-tidy drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc52xx-psc-spi-master-driver-update-tidy
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -540,7 +540,10 @@ static int __exit mpc52xx_psc_spi_do_rem
 static int __init mpc52xx_psc_spi_probe(struct platform_device *dev)
 {
 	switch(dev->id) {
-	case 1: case 2: case 3: case 6:
+	case 1:
+	case 2:
+	case 3:
+	case 6:
 		return mpc52xx_psc_spi_do_probe(&dev->dev,
 			MPC52xx_PA(MPC52xx_PSCx_OFFSET(dev->id)),
 			MPC52xx_PSC_SIZE, platform_get_irq(dev, 0), dev->id);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-hexdump.patch
stop_machine-now-uses-hard_irq_disable.patch
submitchecklist-add-W-help.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
use-defines-in-sys_getpriority-sys_setpriority-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
pm3fb-preliminary-24-to-26-port-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
