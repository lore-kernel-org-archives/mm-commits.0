From: akpm@linux-foundation.org
Subject: [folded-merged] ipcmsg-document-barriers-fix.patch removed from
 -mm tree
Date: Mon, 27 Jan 2014 16:56:11 -0800
Message-ID: <52e7002b.PN/wC0gt9wbKWtOC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaA1A4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 19:56:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr@hp.com, bitbucket@online.de, akpm@linux-foundation.org

Subject: [folded-merged] ipcmsg-document-barriers-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,bitbucket@online.de,davidlohr@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 16:56:11 -0800


The patch titled
     Subject: ipcmsg-document-barriers-fix
has been removed from the -mm tree.  Its filename was
     ipcmsg-document-barriers-fix.patch

This patch was dropped because it was folded into ipcmsg-document-barriers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipcmsg-document-barriers-fix

fix typo, per Mike

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/msg.c~ipcmsg-document-barriers-fix ipc/msg.c
--- a/ipc/msg.c~ipcmsg-document-barriers-fix
+++ a/ipc/msg.c
@@ -258,7 +258,7 @@ static void expunge_all(struct msg_queue
 		/*
 		 * Ensure that the wakeup is visible before setting r_msg as
 		 * the receiving end depends on it: either spinning on a nil,
-		 * or dealing with -EAGAIN cases. See lockless reveice part 1
+		 * or dealing with -EAGAIN cases. See lockless receive part 1
 		 * and 2 in do_msgrcv().
 		 */
 		smp_mb();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipcmsg-document-barriers.patch
ipcmsg-document-barriers-fix-fix.patch

