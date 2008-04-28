From: akpm@linux-foundation.org
Subject: - listh-add-list_singleton-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:57:51 -0700
Message-ID: <200804280657.m3S6vpU2012873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763142AbYD1G66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     list.h: rename list_singleton to list_is_singular
has been removed from the -mm tree.  Its filename was
     listh-add-list_singleton-fix.patch

This patch was dropped because it was folded into listh-add-list_singleton.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: list.h: rename list_singleton to list_is_singular
From: Masami Hiramatsu <mhiramat@redhat.com>

Rename list_singleton to list_is_singular.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/list.h~listh-add-list_singleton-fix include/linux/list.h
--- a/include/linux/list.h~listh-add-list_singleton-fix
+++ a/include/linux/list.h
@@ -212,10 +212,10 @@ static inline int list_empty_careful(con
 }
 
 /**
- * list_singleton - tests whether a list has just one entry.
+ * list_is_singular - tests whether a list has just one entry.
  * @head: the list to test.
  */
-static inline int list_singleton(const struct list_head *head)
+static inline int list_is_singular(const struct list_head *head)
 {
 	return !list_empty(head) && (head->next == head->prev);
 }
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
listh-add-list_singleton.patch
listh-add-list_singleton-fix.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

