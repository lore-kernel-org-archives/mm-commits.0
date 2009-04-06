From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-hvc_console.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:36 -0700
Message-ID: <200904061932.n36JWaJb010793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084AbZDFTfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add hvc_console
has been removed from the -mm tree.  Its filename was
     maintainers-add-hvc_console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

