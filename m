From: akpm@linux-foundation.org
Subject: [merged] ipc-sem-drop-sem_checkid-helper.patch removed
 from -mm tree
Date: Mon, 11 Sep 2017 12:44:19 -0700
Message-ID: <20170911194419.cYwyk8kWN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdIKToU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: drop sem_checkid helper
has been removed from the -mm tree.  Its filename was
     ipc-sem-drop-sem_checkid-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: drop sem_checkid helper

... 'tis not used.

Link: http://lkml.kernel.org/r/20170803184136.13855-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN ipc/sem.c~ipc-sem-drop-sem_checkid-helper ipc/sem.c
--- a/ipc/sem.c~ipc-sem-drop-sem_checkid-helper
+++ a/ipc/sem.c
@@ -130,8 +130,6 @@ struct sem_undo_list {
 
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
-#define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
