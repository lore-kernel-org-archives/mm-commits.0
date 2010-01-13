From: akpm@linux-foundation.org
Subject: [alternative-merged] sort-introduce-generic-list_sort-function-v3.patch removed from -mm tree
Date: Wed, 13 Jan 2010 11:28:24 -0800
Message-ID: <201001131928.o0DJSOnI023802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0AMT24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 14:28:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fromorbit.com, airlied@redhat.com, dedekind@infradead.org, mm-commits@vger.kernel.org


The patch titled
     sort-introduce-generic-list_sort-function-v3.txt
has been removed from the -mm tree.  Its filename was
     sort-introduce-generic-list_sort-function-v3.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sort-introduce-generic-list_sort-function-v3.txt
From: Dave Chinner <david@fromorbit.com>

V3: Export list_sort()

Cc: Dave Airlie <airlied@redhat.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/sort.c~sort-introduce-generic-list_sort-function-v3 lib/sort.c
--- a/lib/sort.c~sort-introduce-generic-list_sort-function-v3
+++ a/lib/sort.c
@@ -218,3 +218,4 @@ void list_sort(void *priv, struct list_h
 	list->prev = head;
 }
 
+EXPORT_SYMBOL(list_sort);
_

Patches currently in -mm which might be from david@fromorbit.com are

linux-next.patch
sort-introduce-generic-list_sort-function-v3.patch
sort-introduce-generic-list_sort-function-v3-checkpatch-fixes.patch

