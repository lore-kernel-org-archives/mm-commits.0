From: akpm@linux-foundation.org
Subject: + maintainers-quote-non-alphanumeric-email-addresses.patch added to -mm tree
Date: Wed, 23 Feb 2011 15:32:06 -0800
Message-ID: <201102232332.p1NNW7On029541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab1BWXcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 18:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, harryxiyou@gmail.com, jlee@novell.com, mark.brown314@gmail.com, padovan@profusion.mobi, scameron@beardog.cce.hp.com


The patch titled
     MAINTAINERS: quote non-alphanumeric email addresses
has been added to the -mm tree.  Its filename is
     maintainers-quote-non-alphanumeric-email-addresses.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-quote-non-alphanumeric-email-addresses MAINTAINERS
--- a/MAINTAINERS~maintainers-quote-non-alphanumeric-email-addresses
+++ a/MAINTAINERS
@@ -1054,7 +1054,7 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Maintained
 
 ARM/TETON BGA MACHINE SUPPORT
-M:	Mark F. Brown <mark.brown314@gmail.com>
+M:	"Mark F. Brown" <mark.brown314@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -1458,7 +1458,7 @@ F:	drivers/mtd/devices/block2mtd.c
 
 BLUETOOTH DRIVERS
 M:	Marcel Holtmann <marcel@holtmann.org>
-M:	Gustavo F. Padovan <padovan@profusion.mobi>
+M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
@@ -1467,7 +1467,7 @@ F:	drivers/bluetooth/
 
 BLUETOOTH SUBSYSTEM
 M:	Marcel Holtmann <marcel@holtmann.org>
-M:	Gustavo F. Padovan <padovan@profusion.mobi>
+M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
@@ -2925,7 +2925,7 @@ F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
-M:	Stephen M. Cameron <scameron@beardog.cce.hp.com>
+M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
 L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/scsi/hpsa.txt
@@ -4213,7 +4213,7 @@ F:	Documentation/serial/moxa-smartio
 F:	drivers/char/mxser.*
 
 MSI LAPTOP SUPPORT
-M:	Lee, Chun-Yi <jlee@novell.com>
+M:	"Lee, Chun-Yi" <jlee@novell.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/msi-laptop.c
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-chinese-documentation-maintainer.patch
vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch
printk-allow-setting-default_message_level-via-kconfig.patch
get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.patch
maintainers-quote-non-alphanumeric-email-addresses.patch

