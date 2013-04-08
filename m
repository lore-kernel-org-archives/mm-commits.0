From: akpm@linux-foundation.org
Subject: [obsolete] scsi-rename-random32-to-prandom_u32-fix.patch removed from -mm tree
Date: Mon, 08 Apr 2013 12:13:40 -0700
Message-ID: <20130408191340.7E93831C123@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:42132 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935227Ab3DHTNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 15:13:45 -0400
Received: by mail-ia0-f201.google.com with SMTP id k25so444377iah.2
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 12:13:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, JBottomley@parallels.com, andrew.vasquez@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: fix the wrong position of the comment
has been removed from the -mm tree.  Its filename was
     scsi-rename-random32-to-prandom_u32-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: scsi: fix the wrong position of the comment

This fixes the wrong position of the comment introduced by
scsi-rename-random32-to-prandom_u32.patch in the -mm tree.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_attr.c~scsi-rename-random32-to-prandom_u32-fix drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~scsi-rename-random32-to-prandom_u32-fix
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc
 	}
 
 	/* No pending activities shall be there on the vha now */
-	if (ql2xextended_error_logging & ql_dbg_user)
-		msleep(prandom_u32() % 10);
+	if (ql2xextended_error_logging & ql_dbg_user) {
 		/*
 		 * Just to see if something falls on the net we have placed
 		 * below
 		 */
-
+		msleep(prandom_u32() % 10);
+	}
 	BUG_ON(atomic_read(&vha->vref_count));
 
 	qla2x00_free_fcports(vha);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

