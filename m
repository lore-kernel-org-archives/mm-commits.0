From: akpm@linux-foundation.org
Subject: [merged] maintainers-quote-non-alphanumeric-email-addresses.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:37 -0700
Message-ID: <201103232043.p2NKhDjx028843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933349Ab1CWUzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, harryxiyou@gmail.com, jlee@novell.com, mark.brown314@gmail.com, padovan@profusion.mobi, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: quote non-alphanumeric email addresses
has been removed from the -mm tree.  Its filename was
     maintainers-quote-non-alphanumeric-email-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: quote non-alphanumeric email addresses
From: Joe Perches <joe@perches.com>

Add quotes around email address with periods and commas.  So they don't
explode when pasted into certain email clients.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "Lee, Chun-Yi" <jlee@novell.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-quote-non-alphanumeric-email-addresses MAINTAINERS
--- a/MAINTAINERS~maintainers-quote-non-alphanumeric-email-addresses
+++ a/MAINTAINERS
@@ -1078,7 +1078,7 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Maintained
 
 ARM/TETON BGA MACHINE SUPPORT
-M:	Mark F. Brown <mark.brown314@gmail.com>
+M:	"Mark F. Brown" <mark.brown314@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -1482,7 +1482,7 @@ F:	drivers/mtd/devices/block2mtd.c
 
 BLUETOOTH DRIVERS
 M:	Marcel Holtmann <marcel@holtmann.org>
-M:	Gustavo F. Padovan <padovan@profusion.mobi>
+M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
@@ -1491,7 +1491,7 @@ F:	drivers/bluetooth/
 
 BLUETOOTH SUBSYSTEM
 M:	Marcel Holtmann <marcel@holtmann.org>
-M:	Gustavo F. Padovan <padovan@profusion.mobi>
+M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
@@ -2950,7 +2950,7 @@ F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
-M:	Stephen M. Cameron <scameron@beardog.cce.hp.com>
+M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
 L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/scsi/hpsa.txt
@@ -4232,7 +4232,7 @@ F:	Documentation/serial/moxa-smartio
 F:	drivers/char/mxser.*
 
 MSI LAPTOP SUPPORT
-M:	Lee, Chun-Yi <jlee@novell.com>
+M:	"Lee, Chun-Yi" <jlee@novell.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/msi-laptop.c
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

