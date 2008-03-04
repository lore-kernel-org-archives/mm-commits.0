From: akpm@linux-foundation.org
Subject: - usb-fix-comment-of-struct-usb_interface.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:47 -0800
Message-ID: <200803042009.m24K9lYQ026787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765684AbYCDUKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:10:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     fix comment of struct usb_interface
has been removed from the -mm tree.  Its filename was
     usb-fix-comment-of-struct-usb_interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


