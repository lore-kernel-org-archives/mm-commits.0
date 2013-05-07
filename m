From: akpm@linux-foundation.org
Subject: [merged] ipc-msgutilc-use-linux-uaccessh.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:07 -0700
Message-ID: <20130507175207.6EE3631C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59835 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3EGRwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:08 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so110883qae.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rain6557@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msgutil.c: use linux/uaccess.h
has been removed from the -mm tree.  Its filename was
     ipc-msgutilc-use-linux-uaccessh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HoSung Jung <rain6557@gmail.com>
Subject: ipc/msgutil.c: use linux/uaccess.h

Signed-off-by: HoSung Jung <rain6557@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/msgutil.c~ipc-msgutilc-use-linux-uaccessh ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-msgutilc-use-linux-uaccessh
+++ a/ipc/msgutil.c
@@ -17,7 +17,7 @@
 #include <linux/ipc_namespace.h>
 #include <linux/utsname.h>
 #include <linux/proc_ns.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "util.h"
 
@@ -37,7 +37,7 @@ struct ipc_namespace init_ipc_ns = {
 atomic_t nr_ipc_ns = ATOMIC_INIT(1);
 
 struct msg_msgseg {
-	struct msg_msgseg* next;
+	struct msg_msgseg *next;
 	/* the next part of the message follows immediately */
 };
 
_

Patches currently in -mm which might be from rain6557@gmail.com are

origin.patch

