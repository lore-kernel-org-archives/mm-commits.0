From: akpm@linux-foundation.org
Subject: + include-linux-resourceh-needs-typesh.patch added to -mm tree
Date: Fri, 05 Nov 2010 12:18:13 -0700
Message-ID: <201011051918.oA5JIEm2027950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab0KETSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 15:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org


The patch titled
     include/linux/resource.h needs types.h
has been added to the -mm tree.  Its filename is
     include-linux-resourceh-needs-typesh.patch

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
Subject: include/linux/resource.h needs types.h
From: Jean Delvare <khali@linux-fr.org>

Fix the following warning:
usr/include/linux/resource.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/resource.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/resource.h~include-linux-resourceh-needs-typesh include/linux/resource.h
--- a/include/linux/resource.h~include-linux-resourceh-needs-typesh
+++ a/include/linux/resource.h
@@ -2,6 +2,7 @@
 #define _LINUX_RESOURCE_H
 
 #include <linux/time.h>
+#include <linux/types.h>
 
 /*
  * Resource control/accounting header file for linux
_

Patches currently in -mm which might be from khali@linux-fr.org are

include-linux-resourceh-needs-typesh.patch
linux-next.patch
leds-driver-for-national-semiconductor-lp5521-chip.patch
leds-driver-for-national-semiconductors-lp5523-chip.patch
leds-update-lp552x-support-kconfig-and-makefile.patch
documentation-led-drivers-lp5521-and-lp5523.patch

