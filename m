From: akpm@linux-foundation.org
Subject: + maintainers-add-hvc_console.patch added to -mm tree
Date: Wed, 01 Apr 2009 14:18:03 -0700
Message-ID: <200904012118.n31LI3hO022284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391AbZDAVUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 17:20:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com


The patch titled
     MAINTAINERS: add hvc_console
has been added to the -mm tree.  Its filename is
     maintainers-add-hvc_console.patch

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
Subject: MAINTAINERS: add hvc_console
From: Michael Ellerman <michael@ellerman.id.au>

Add a MAINTAINERS entry for the hypervisor virtual console driver.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-hvc_console MAINTAINERS
--- a/MAINTAINERS~maintainers-add-hvc_console
+++ a/MAINTAINERS
@@ -1945,6 +1945,12 @@ L:	lm-sensors@lm-sensors.org
 W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
 S:	Maintained
 
+HYPERVISOR VIRTUAL CONSOLE DRIVER
+L:	linuxppc-dev@ozlabs.org
+L:	linux-kernel@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/char/hvc_*
+
 GSPCA FINEPIX SUBDRIVER
 P:	Frank Zago
 M:	frank@zago.net
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch
maintainers-add-hvc_console.patch

