From: akpm@linux-foundation.org
Subject: - drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:26 -0700
Message-ID: <200710051958.l95JwQTv022545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762735AbXJEUBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/misc/sisusbvga/sisusb.c: kill two unused variables
has been removed from the -mm tree.  Its filename was
     drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/usb/misc/sisusbvga/sisusb.c: kill two unused variables
From: WANG Cong <xiyou.wangcong@gmail.com>

Kill two unused variables in drivers/usb/misc/sisusbvga/sisusb.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/sisusbvga/sisusb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/usb/misc/sisusbvga/sisusb.c~drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables drivers/usb/misc/sisusbvga/sisusb.c
--- a/drivers/usb/misc/sisusbvga/sisusb.c~drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables
+++ a/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3316,8 +3316,6 @@ static struct usb_driver sisusb_driver =
 
 static int __init usb_sisusb_init(void)
 {
-	int retval;
-	struct sisusb_usb_data *sisusb;
 
 #ifdef INCL_SISUSB_CON
 	sisusb_init_concode();
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-net.patch
fs-romfs-inodec-trivial-improvements.patch
fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
