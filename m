From: akpm@linux-foundation.org
Subject: + mmzoneh-remove-dead-prototype.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:15:57 -0700
Message-ID: <201006141915.o5EJFvvY025855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab0FNTQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.nevenchannyy@gmail.com


The patch titled
     mmzone.h: remove dead prototype
has been added to the -mm tree.  Its filename is
     mmzoneh-remove-dead-prototype.patch

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
Subject: mmzone.h: remove dead prototype
From: Alexander Nevenchannyy <a.nevenchannyy@gmail.com>

get_zone_counts() was dropped from kernel tree, see:
http://www.mail-archive.com/mm-commits@vger.kernel.org/msg07313.html but
its prototype remains.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/mmzone.h~mmzoneh-remove-dead-prototype include/linux/mmzone.h
--- a/include/linux/mmzone.h~mmzoneh-remove-dead-prototype
+++ a/include/linux/mmzone.h
@@ -651,8 +651,6 @@ typedef struct pglist_data {
 #include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
-void get_zone_counts(unsigned long *active, unsigned long *inactive,
-			unsigned long *free);
 void build_all_zonelists(void *data);
 void wakeup_kswapd(struct zone *zone, int order);
 int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
_

Patches currently in -mm which might be from a.nevenchannyy@gmail.com are

mmzoneh-remove-dead-prototype.patch

