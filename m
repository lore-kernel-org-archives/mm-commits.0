From: akpm@linux-foundation.org
Subject: + ftdi_sio-fix-product-parameter-description.patch added to -mm tree
Date: Thu, 11 Sep 2008 11:57:31 -0700
Message-ID: <200809111857.m8BIvVsP011148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbYIKS5l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 14:57:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulius.zaleckas@teltonika.lt, greg@kroah.com


The patch titled
     ftdi_sio: fix 'product' parameter description
has been added to the -mm tree.  Its filename is
     ftdi_sio-fix-product-parameter-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

ftdi_sio-fix-product-parameter-description.patch

