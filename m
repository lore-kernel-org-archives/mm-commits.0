From: akpm@linux-foundation.org
Subject: - qla2xxx-use-memory_read_from_buffer-fix.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:48 -0700
Message-ID: <200807282111.m6SLBmvc027721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759813AbYG1VMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, linux-driver@qlogic.com, seokmann.ju@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     fix qla2xxx-use-memory_read_from_buffer.patch
has been removed from the -mm tree.  Its filename was
     qla2xxx-use-memory_read_from_buffer-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix qla2xxx-use-memory_read_from_buffer.patch
From: Akinobu Mita <akinobu.mita@gmail.com>

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_attr.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/qla2xxx/qla_attr.c~qla2xxx-use-memory_read_from_buffer-fix drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~qla2xxx-use-memory_read_from_buffer-fix
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,7 +8,6 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
-#include <linux/fs.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

