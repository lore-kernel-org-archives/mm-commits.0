From: akpm@linux-foundation.org
Subject: + sort-introduce-generic-list_sort-function-v3.patch added to -mm tree
Date: Mon, 11 Jan 2010 23:51:22 -0800
Message-ID: <201001120751.o0C7pMX1023916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab0ALHwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 02:52:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fromorbit.com, airlied@redhat.com, dedekind@infradead.org


The patch titled
     sort-introduce-generic-list_sort-function-v3.txt
has been added to the -mm tree.  Its filename is
     sort-introduce-generic-list_sort-function-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
sort-introduce-generic-list_sort-function.patch
sort-introduce-generic-list_sort-function-v3.patch

