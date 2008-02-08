From: akpm@linux-foundation.org
Subject: - maintainers-add-self-for-the-dz-serial-driver.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:04 -0800
Message-ID: <200802080806.m1886jaE014478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760569AbYBHITf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add self for the dz serial driver
has been removed from the -mm tree.  Its filename was
     maintainers-add-self-for-the-dz-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1371,6 +1371,11 @@ W:	http://linuxtv.org/
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
