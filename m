From: akpm@linux-foundation.org
Subject: + drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch added to -mm tree
Date: Wed, 26 Sep 2007 14:20:15 -0700
Message-ID: <200709262120.l8QLKFtf004475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758818AbXIZVUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 17:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, greg@kroah.com


The patch titled
     drivers/usb/misc/sisusbvga/sisusb.c: kill two unused variables
has been added to the -mm tree.  Its filename is
     drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/usb/misc/sisusbvga/sisusb.c: kill two unused variables
From: WANG Cong <xiyou.wangcong@gmail.com>

Kill two unused variables in drivers/usb/misc/sisusbvga/sisusb.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

net-bluetooth-hidp-corec-make-hidp_setup_input.patch
drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch
fs-romfs-inodec-trivial-improvements.patch
fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
