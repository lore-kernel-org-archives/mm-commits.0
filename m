From: akpm@linux-foundation.org
Subject: + memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch added to -mm tree
Date: Tue, 11 Jan 2011 14:28:48 -0800
Message-ID: <201101112228.p0BMSmEZ010478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab1AKW2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 17:28:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com


The patch titled
     memstick: add Alex Dubov to MAINTAINERS of the memstick core
has been added to the -mm tree.  Its filename is
     memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch

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
Subject: memstick: add Alex Dubov to MAINTAINERS of the memstick core
From: Maxim Levitsky <maximlevitsky@gmail.com>

This code is supposed to be maintained by him and unless he doesn't want
to do so, MAINTAINERS should reflect the state of things, and bugreporters
should know whom to blame for bugs.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~memstick-add-alex-dubov-to-maintainers-of-the-memstick-core MAINTAINERS
--- a/MAINTAINERS~memstick-add-alex-dubov-to-maintainers-of-the-memstick-core
+++ a/MAINTAINERS
@@ -5761,7 +5761,18 @@ F:	drivers/char/sonypi.c
 F:	drivers/platform/x86/sony-laptop.c
 F:	include/linux/sony-laptop.h
 
-SONY MEMORYSTICK CARD SUPPORT
+SONY MEMORYSTICK SUBSYSTEM
+M:	Alex Dubov <oakad@yahoo.com>
+S:	Maintained
+F:	drivers/memstick/memstick.c
+F:	drivers/memstick/mspro_block.c
+
+SONY MEMORYSTICK DRIVER FOR JMICRON CONTRLLERS
+M:	Alex Dubov <oakad@yahoo.com>
+S:	Maintained
+F:	drivers/memstick/host/jmb38x_ms.c
+
+SONY MEMORYSTICK DRIVER FOR TI CONTROLLERS
 M:	Alex Dubov <oakad@yahoo.com>
 W:	http://tifmxx.berlios.de/
 S:	Maintained
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

origin.patch
memstick-core-fix-device_register-error-handling.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch

