From: akpm@linux-foundation.org
Subject: + drivers-message-i2o-iopc-cleanup-kerneldoc.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:42:14 -0800
Message-ID: <200811122242.mACMgEPA032129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055AbYKLWnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:43:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, randy.dunlap@oracle.com


The patch titled
     drivers/message/i2o/iop.c: cleanup kerneldoc
has been added to the -mm tree.  Its filename is
     drivers-message-i2o-iopc-cleanup-kerneldoc.patch

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
Subject: drivers/message/i2o/iop.c: cleanup kerneldoc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

no argument named @msg in i2o_msg_get_wait(), remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/iop.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/message/i2o/iop.c~drivers-message-i2o-iopc-cleanup-kerneldoc drivers/message/i2o/iop.c
--- a/drivers/message/i2o/iop.c~drivers-message-i2o-iopc-cleanup-kerneldoc
+++ a/drivers/message/i2o/iop.c
@@ -49,7 +49,6 @@ static int i2o_hrt_get(struct i2o_contro
 /**
  *	i2o_msg_get_wait - obtain an I2O message from the IOP
  *	@c: I2O controller
- *	@msg: pointer to a I2O message pointer
  *	@wait: how long to wait until timeout
  *
  *	This function waits up to wait seconds for a message slot to be
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch

