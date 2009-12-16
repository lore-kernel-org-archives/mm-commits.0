From: akpm@linux-foundation.org
Subject: [merged] parport_pcc-use-correct-length-in-strncmp.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:25 -0800
Message-ID: <200912162039.nBGKdPkH013532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964985AbZLPUj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     parport_pc.c: use correct length in strncmp
has been removed from the -mm tree.  Its filename was
     parport_pcc-use-correct-length-in-strncmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport_pc.c: use correct length in strncmp
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/parport_pc.c~parport_pcc-use-correct-length-in-strncmp drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pcc-use-correct-length-in-strncmp
+++ a/drivers/parport/parport_pc.c
@@ -3403,7 +3403,7 @@ static int __init parport_parse_param(co
 		*val = automatic;
 	else if (!strncmp(s, "none", 4))
 		*val = none;
-	else if (nofifo && !strncmp(s, "nofifo", 4))
+	else if (nofifo && !strncmp(s, "nofifo", 6))
 		*val = nofifo;
 	else {
 		char *ep;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch

