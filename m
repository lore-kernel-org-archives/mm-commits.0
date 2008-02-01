From: akpm@linux-foundation.org
Subject: - add-build-support-for-new-coldfire-serial-driver.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:47 -0800
Message-ID: <200802012229.m11MTlsM001826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756304AbYBAWay (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:30:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     add build support for new ColdFire serial driver
has been removed from the -mm tree.  Its filename was
     add-build-support-for-new-coldfire-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add build support for new ColdFire serial driver
From: Greg Ungerer <gerg@snapgear.com>

Add build support for the new style ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/Makefile~add-build-support-for-new-coldfire-serial-driver drivers/serial/Makefile
--- a/drivers/serial/Makefile~add-build-support-for-new-coldfire-serial-driver
+++ a/drivers/serial/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_SERIAL_MUX) += mux.o
 obj-$(CONFIG_SERIAL_68328) += 68328serial.o
 obj-$(CONFIG_SERIAL_68360) += 68360serial.o
 obj-$(CONFIG_SERIAL_COLDFIRE) += mcfserial.o
+obj-$(CONFIG_SERIAL_MCF) += mcf.o
 obj-$(CONFIG_V850E_UART) += v850e_uart.o
 obj-$(CONFIG_SERIAL_PMACZILOG) += pmac_zilog.o
 obj-$(CONFIG_SERIAL_LH7A40X) += serial_lh7a40x.o
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
add-cmpxchg_local-to-m68knommu.patch
