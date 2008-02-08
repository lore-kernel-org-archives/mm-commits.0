From: akpm@linux-foundation.org
Subject: - 8250_hub6-codding-style.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:58 -0800
Message-ID: <200802082012.m18KCdkw010221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894AbYBHUsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:48:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     8250_hub6: codding style
has been removed from the -mm tree.  Its filename was
     8250_hub6-codding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250_hub6: codding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_hub6.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/serial/8250_hub6.c~8250_hub6-codding-style drivers/serial/8250_hub6.c
--- a/drivers/serial/8250_hub6.c~8250_hub6-codding-style
+++ a/drivers/serial/8250_hub6.c
@@ -23,18 +23,18 @@
 	}
 
 static struct plat_serial8250_port hub6_data[] = {
-	HUB6(0,0),
-	HUB6(0,1),
-	HUB6(0,2),
-	HUB6(0,3),
-	HUB6(0,4),
-	HUB6(0,5),
-	HUB6(1,0),
-	HUB6(1,1),
-	HUB6(1,2),
-	HUB6(1,3),
-	HUB6(1,4),
-	HUB6(1,5),
+	HUB6(0, 0),
+	HUB6(0, 1),
+	HUB6(0, 2),
+	HUB6(0, 3),
+	HUB6(0, 4),
+	HUB6(0, 5),
+	HUB6(1, 0),
+	HUB6(1, 1),
+	HUB6(1, 2),
+	HUB6(1, 3),
+	HUB6(1, 4),
+	HUB6(1, 5),
 	{ },
 };
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
