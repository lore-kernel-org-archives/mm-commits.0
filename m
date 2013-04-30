From: akpm@linux-foundation.org
Subject: [merged] maintainers-petko-has-moved.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:08 -0700
Message-ID: <20130430185108.6546E31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:53444 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:09 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86030yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petkan@nucleusys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Petko has moved
has been removed from the -mm tree.  Its filename was
     maintainers-petko-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petko Manolov <petkan@nucleusys.com>
Subject: MAINTAINERS: Petko has moved

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-petko-has-moved MAINTAINERS
--- a/MAINTAINERS~maintainers-petko-has-moved
+++ a/MAINTAINERS
@@ -8382,9 +8382,10 @@ S:	Maintained
 F:	drivers/usb/serial/option.c
 
 USB PEGASUS DRIVER
-M:	Petko Manolov <petkan@users.sourceforge.net>
+M:	Petko Manolov <petkan@nucleusys.com>
 L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
+T:	git git://git.code.sf.net/p/pegasus2/git
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/pegasus.*
@@ -8404,9 +8405,10 @@ S:	Supported
 F:	drivers/usb/class/usblp.c
 
 USB RTL8150 DRIVER
-M:	Petko Manolov <petkan@users.sourceforge.net>
+M:	Petko Manolov <petkan@nucleusys.com>
 L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
+T:	git git://git.code.sf.net/p/pegasus2/git
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/rtl8150.c
_

Patches currently in -mm which might be from petkan@nucleusys.com are

origin.patch
linux-next.patch

