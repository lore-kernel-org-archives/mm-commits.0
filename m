From: akpm@linux-foundation.org
Subject: + maintainers-add-self-for-the-dz-serial-driver.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:26:11 -0700
Message-ID: <200710192126.l9JLQBoa020955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934792AbXJSV05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jirislaby@gmail.com


The patch titled
     MAINTAINERS: add self for the dz serial driver
has been added to the -mm tree.  Its filename is
     maintainers-add-self-for-the-dz-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS: add self for the dz serial driver
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Now that I have got the necessary piece of hardware (thanks, Thiemo!), I may
well offer myself as the maintainer for the dz serial driver.  I hope nobody
objects.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-add-self-for-the-dz-serial-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-self-for-the-dz-serial-driver
+++ a/MAINTAINERS
@@ -1374,6 +1374,11 @@ W:	http://linuxtv.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 
+DZ DECSTATION DZ11 SERIAL DRIVER
+P:	Maciej W. Rozycki
+M:	macro@linux-mips.org
+S:	Maintained
+
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
 L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
