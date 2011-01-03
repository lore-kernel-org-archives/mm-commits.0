From: akpm@linux-foundation.org
Subject: + maintainers-remove-stelian-from-the-ams-driver-record.patch added to -mm tree
Date: Mon, 03 Jan 2011 11:27:54 -0800
Message-ID: <201101031927.p03JRsq4024463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958Ab1ACT2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 14:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stelian@popies.net, linux-kernel@hansmi.ch


The patch titled
     MAINTAINERS: remove Stelian from the AMS driver record
has been added to the -mm tree.  Its filename is
     maintainers-remove-stelian-from-the-ams-driver-record.patch

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
Subject: MAINTAINERS: remove Stelian from the AMS driver record
From: Stelian Pop <stelian@popies.net>

This driver is PPC only, and I am no longer able to test it.

Signed-off-by: Stelian Pop <stelian@popies.net>
Cc: Michael Hanselmann <linux-kernel@hansmi.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-stelian-from-the-ams-driver-record MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-stelian-from-the-ams-driver-record
+++ a/MAINTAINERS
@@ -429,7 +429,6 @@ S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
-M:	Stelian Pop <stelian@popies.net>
 M:	Michael Hanselmann <linux-kernel@hansmi.ch>
 S:	Supported
 F:	drivers/macintosh/ams/
_

Patches currently in -mm which might be from stelian@popies.net are

credits-update-stelians-entry.patch
maintainers-orphan-the-meye-driver.patch
maintainers-remove-stelian-from-the-ams-driver-record.patch

