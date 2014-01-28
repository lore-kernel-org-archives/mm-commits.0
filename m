From: akpm@linux-foundation.org
Subject: [folded-merged] ipcmsg-document-barriers-fix-fix.patch removed
 from -mm tree
Date: Mon, 27 Jan 2014 16:56:13 -0800
Message-ID: <52e7002d.eJzXemB4Tv2XClRl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaA1A4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 19:56:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr@hp.com, bitbucket@online.de, akpm@linux-foundation.org

Subject: [folded-merged] ipcmsg-document-barriers-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,bitbucket@online.de,davidlohr@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 16:56:13 -0800


The patch titled
     Subject: ipcmsg-document-barriers-fix-fix
has been removed from the -mm tree.  Its filename was
     ipcmsg-document-barriers-fix-fix.patch

This patch was dropped because it was folded into ipcmsg-document-barriers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipcmsg-document-barriers-fix-fix

mroe tpyos

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/msg.c~ipcmsg-document-barriers-fix-fix ipc/msg.c
--- a/ipc/msg.c~ipcmsg-document-barriers-fix-fix
+++ a/ipc/msg.c
@@ -657,7 +657,7 @@ static inline int pipelined_send(struct
 				/*
 				 * Ensure that the wakeup is visible before
 				 * setting r_msg, as the receiving end depends
-				 * on it. See lockless reveice part 1 and 2 in
+				 * on it. See lockless receive part 1 and 2 in
 				 * do_msgrcv().
 				 */
 				smp_mb();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipcmsg-document-barriers.patch

