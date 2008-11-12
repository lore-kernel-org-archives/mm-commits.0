From: akpm@linux-foundation.org
Subject: + drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:42:16 -0800
Message-ID: <200811122242.mACMgGkJ032134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYKLWnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:43:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, greg@kroah.com, randy.dunlap@oracle.com


The patch titled
     drivers/staging/usbip/stub_tx.c: cleanup kerneldoc
has been added to the -mm tree.  Its filename is
     drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/usbip/stub_tx.c: cleanup kerneldoc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

No argument named @regs in stub_complete(), remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/usbip/stub_tx.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/staging/usbip/stub_tx.c~drivers-staging-usbip-stub_txc-cleanup-kerneldoc drivers/staging/usbip/stub_tx.c
--- a/drivers/staging/usbip/stub_tx.c~drivers-staging-usbip-stub_txc-cleanup-kerneldoc
+++ a/drivers/staging/usbip/stub_tx.c
@@ -54,7 +54,6 @@ void stub_enqueue_ret_unlink(struct stub
 /**
  * stub_complete - completion handler of a usbip urb
  * @urb: pointer to the urb completed
- * @regs:
  *
  * When a urb has completed, the USB core driver calls this function mostly in
  * the interrupt context. To return the result of a urb, the completed urb is
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch

