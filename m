From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-johan-to-bluetooth-maintainers.patch removed from -mm tree
Date: Fri, 16 Mar 2012 13:58:01 -0700
Message-ID: <20120316205801.6493CA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64288 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031888Ab2CPU6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 16:58:03 -0400
Received: by eekc41 with SMTP id c41so214937eek.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 13:58:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan.hedberg@intel.com, marcel@holtmann.org, padovan@profusion.mobi, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Johan to Bluetooth maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-add-johan-to-bluetooth-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johan Hedberg <johan.hedberg@intel.com>
Subject: MAINTAINERS: add Johan to Bluetooth maintainers

I've been coordinating Bluetooth patches in my tree for some time and it's
possible I'll do it in the future too, so add myself to the Bluetooth
sections as well as mention my tree there.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN MAINTAINERS~maintainers-add-johan-to-bluetooth-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-johan-to-bluetooth-maintainers
+++ a/MAINTAINERS
@@ -1514,18 +1514,22 @@ F:	drivers/mtd/devices/block2mtd.c
 BLUETOOTH DRIVERS
 M:	Marcel Holtmann <marcel@holtmann.org>
 M:	Gustavo Padovan <gustavo@padovan.org>
+M:	Johan Hedberg <johan.hedberg@gmail.com>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth.git
 S:	Maintained
 F:	drivers/bluetooth/
 
 BLUETOOTH SUBSYSTEM
 M:	Marcel Holtmann <marcel@holtmann.org>
 M:	Gustavo Padovan <gustavo@padovan.org>
+M:	Johan Hedberg <johan.hedberg@gmail.com>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth.git
 S:	Maintained
 F:	net/bluetooth/
 F:	include/net/bluetooth/
_

Patches currently in -mm which might be from johan.hedberg@intel.com are

origin.patch
linux-next.patch

