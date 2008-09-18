From: akpm@linux-foundation.org
Subject: - ftdi_sio-fix-product-parameter-description.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:49 -0700
Message-ID: <200809182056.m8IKun1L019222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbYIRU5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulius.zaleckas@teltonika.lt, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     ftdi_sio: fix 'product' parameter description
has been removed from the -mm tree.  Its filename was
     ftdi_sio-fix-product-parameter-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftdi_sio: fix 'product' parameter description
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/ftdi_sio.c~ftdi_sio-fix-product-parameter-description drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~ftdi_sio-fix-product-parameter-description
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -2475,5 +2475,5 @@ module_param(vendor, ushort, 0);
 MODULE_PARM_DESC(vendor, "User specified vendor ID (default="
 		__MODULE_STRING(FTDI_VID)")");
 module_param(product, ushort, 0);
-MODULE_PARM_DESC(vendor, "User specified product ID");
+MODULE_PARM_DESC(product, "User specified product ID");
 
_

Patches currently in -mm which might be from paulius.zaleckas@teltonika.lt are

linux-next.patch

