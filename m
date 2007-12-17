From: akpm@linux-foundation.org
Subject: - drivers-scsi-iprc-use-list_head-instead-of-list_head_init.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:30 -0800
Message-ID: <200712172340.lBHNeUEM008296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756929AbXLRACX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 19:02:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, brking@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/ipr.c: use LIST_HEAD instead of LIST_HEAD_INIT
has been removed from the -mm tree.  Its filename was
     drivers-scsi-iprc-use-list_head-instead-of-list_head_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/ipr.c: use LIST_HEAD instead of LIST_HEAD_INIT
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~drivers-scsi-iprc-use-list_head-instead-of-list_head_init drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~drivers-scsi-iprc-use-list_head-instead-of-list_head_init
+++ a/drivers/scsi/ipr.c
@@ -84,7 +84,7 @@
 /*
  *   Global Data
  */
-static struct list_head ipr_ioa_head = LIST_HEAD_INIT(ipr_ioa_head);
+static LIST_HEAD(ipr_ioa_head);
 static unsigned int ipr_log_level = IPR_DEFAULT_LOG_LEVEL;
 static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
git-md-accel.patch
git-net.patch
git-s390.patch
git-scsi-misc.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
git-cryptodev.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch
fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch
