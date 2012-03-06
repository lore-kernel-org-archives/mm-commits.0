From: akpm@linux-foundation.org
Subject: + maintainers-add-johan-to-bluetooth-maintainers.patch added to -mm tree
Date: Tue, 06 Mar 2012 14:13:07 -0800
Message-ID: <20120306221308.7B6E5A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:40261 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031101Ab2CFWNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 17:13:11 -0500
Received: by vcbfk26 with SMTP id fk26so701185vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 14:13:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johan.hedberg@intel.com, marcel@holtmann.org, padovan@profusion.mobi


The patch titled
     Subject: MAINTAINERS: add Johan to Bluetooth maintainers
has been added to the -mm tree.  Its filename is
     maintainers-add-johan-to-bluetooth-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
+M:	Johan Hedberg <johan.hedberg@gmail.com>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth.git
 S:	Maintained
 F:	drivers/bluetooth/
 
 BLUETOOTH SUBSYSTEM
 M:	Marcel Holtmann <marcel@holtmann.org>
 M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
+M:	Johan Hedberg <johan.hedberg@gmail.com>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth.git
 S:	Maintained
 F:	net/bluetooth/
 F:	include/net/bluetooth/
_
Subject: Subject: MAINTAINERS: add Johan to Bluetooth maintainers

Patches currently in -mm which might be from johan.hedberg@intel.com are

linux-next.patch
maintainers-add-johan-to-bluetooth-maintainers.patch
maintainers-fix-link-to-gustavo-padovans-tree.patch

