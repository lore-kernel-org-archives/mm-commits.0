From: akpm@linux-foundation.org
Subject: - usb-take-over-usblp.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:40 -0700
Message-ID: <200706250921.l5P9LeYv031136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbXFYJYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zaitcev@redhat.com, vojtech@suse.cz, mm-commits@vger.kernel.org


The patch titled
     USB: take over usblp
has been removed from the -mm tree.  Its filename was
     usb-take-over-usblp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: take over usblp
From: Pete Zaitcev <zaitcev@redhat.com>

Vojtech agreed to pass usblp over to me, so if you find bugs don't bug him.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Vojtech Pavlik <vojtech@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~usb-take-over-usblp MAINTAINERS
--- a/MAINTAINERS~usb-take-over-usblp
+++ a/MAINTAINERS
@@ -3761,12 +3761,12 @@ L:	linux-usb-devel@lists.sourceforge.net
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 
-USB PRINTER DRIVER
-P:	Vojtech Pavlik
-M:	vojtech@suse.cz
+USB PRINTER DRIVER (usblp)
+P:	Pete Zaitcev
+M:	zaitcev@redhat.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
-S:	Maintained
+S:	Supported
 
 USB RTL8150 DRIVER
 P:	Petko Manolov
_

Patches currently in -mm which might be from zaitcev@redhat.com are

drivers-block-ubc-use-list_for_each_entry.patch
