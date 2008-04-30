From: akpm@linux-foundation.org
Subject: - ipmi-update-driver-version.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:39 -0700
Message-ID: <200804300544.m3U5idKl029431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756913AbYD3GB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: update driver version
has been removed from the -mm tree.  Its filename was
     ipmi-update-driver-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: update driver version
From: Corey Minyard <cminyard@mvista.com>

Enough bug fixes and changes that we need a new driver version.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-update-driver-version drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-update-driver-version
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -47,7 +47,7 @@
 
 #define PFX "IPMI message handler: "
 
-#define IPMI_DRIVER_VERSION "39.1"
+#define IPMI_DRIVER_VERSION "39.2"
 
 static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

