From: akpm@linux-foundation.org
Subject: + usb-take-over-usblp.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:50:40 -0700
Message-ID: <200706231650.l5NGobI9019562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758848AbXFWQvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zaitcev@redhat.com, vojtech@suse.cz


The patch titled
     USB: take over usblp
has been added to the -mm tree.  Its filename is
     usb-take-over-usblp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
usb-take-over-usblp.patch
