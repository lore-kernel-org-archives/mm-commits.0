From: akpm@linux-foundation.org
Subject: + add-build-support-for-new-coldfire-serial-driver.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:20 -0700
Message-ID: <200711022135.lA2LZKRi012002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbXKBVgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     add build support for new ColdFire serial driver
has been added to the -mm tree.  Its filename is
     add-build-support-for-new-coldfire-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68knommu-fix-pread-pwrite-defines.patch
m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
add-build-support-for-new-coldfire-serial-driver.patch
add-configure-support-for-new-coldfire-serial-driver.patch
m68knommu-platform-setup-for-5206-coldfire-uarts.patch
m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
m68knommu-platform-setup-for-520x-coldfire-uarts.patch
m68knommu-platform-setup-for-5249-coldfire-uarts.patch
m68knommu-platform-setup-for-5272-coldfire-uarts.patch
add-cmpxchg_local-to-m68knommu.patch
