From: akpm@linux-foundation.org
Subject: - drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:35 -0800
Message-ID: <200901082246.n08MkZtg026135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757042AbZAHWrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:47:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, jeremy@goop.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/xen/xenbus/xenbus_client.c: cleanup kerneldoc
has been removed from the -mm tree.  Its filename was
     drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/xen/xenbus/xenbus_client.c: cleanup kerneldoc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

no argument named @xbt in xenbus_switch_state(), remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/xenbus/xenbus_client.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/xen/xenbus/xenbus_client.c~drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc drivers/xen/xenbus/xenbus_client.c
--- a/drivers/xen/xenbus/xenbus_client.c~drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc
+++ a/drivers/xen/xenbus/xenbus_client.c
@@ -136,7 +136,6 @@ EXPORT_SYMBOL_GPL(xenbus_watch_pathfmt);
 /**
  * xenbus_switch_state
  * @dev: xenbus device
- * @xbt: transaction handle
  * @state: new state
  *
  * Advertise in the store a change of the given driver to the given new_state.
@@ -267,7 +266,7 @@ EXPORT_SYMBOL_GPL(xenbus_dev_error);
  * @fmt: error message format
  *
  * Equivalent to xenbus_dev_error(dev, err, fmt, args), followed by
- * xenbus_switch_state(dev, NULL, XenbusStateClosing) to schedule an orderly
+ * xenbus_switch_state(dev, XenbusStateClosing) to schedule an orderly
  * closedown of this driver and its peer.
  */
 
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
linux-next.patch

