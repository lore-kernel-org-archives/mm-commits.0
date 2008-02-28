From: akpm@linux-foundation.org
Subject: + usb-fix-comment-of-struct-usb_interface.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:23:13 -0800
Message-ID: <200802280323.m1S3NDQY013199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbYB1DXP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:23:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom.leiming@gmail.com, greg@kroah.com


The patch titled
     fix comment of struct usb_interface
has been added to the -mm tree.  Its filename is
     usb-fix-comment-of-struct-usb_interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix comment of struct usb_interface
From: Lei Ming <tom.leiming@gmail.com>

Update the comment for the removed "driver" field and being out-of-order of
@cur_altsetting and @num_altsetting.

Signed-off-by: Lei Ming <tom.leiming@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/usb.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/usb.h~usb-fix-comment-of-struct-usb_interface include/linux/usb.h
--- a/include/linux/usb.h~usb-fix-comment-of-struct-usb_interface
+++ a/include/linux/usb.h
@@ -94,10 +94,9 @@ enum usb_interface_condition {
  * @altsetting: array of interface structures, one for each alternate
  * 	setting that may be selected.  Each one includes a set of
  * 	endpoint configurations.  They will be in no particular order.
- * @num_altsetting: number of altsettings defined.
  * @cur_altsetting: the current altsetting.
+ * @num_altsetting: number of altsettings defined.
  * @intf_assoc: interface association descriptor
- * @driver: the USB driver that is bound to this interface.
  * @minor: the minor number assigned to this interface, if this
  *	interface is bound to a driver that uses the USB major number.
  *	If this interface does not use the USB major, this field should
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

usb-remove-unnecessary-type-casting-of-urb-context.patch
usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch
usb-fix-comment-of-struct-usb_interface.patch
