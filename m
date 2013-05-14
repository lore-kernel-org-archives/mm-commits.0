From: akpm@linux-foundation.org
Subject: + rbtree-remove-unneeded-include.patch added to -mm tree
Date: Tue, 14 May 2013 12:32:06 -0700
Message-ID: <51929136.q8EQ6+kh/bOFoHeY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3ENTcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 May 2013 15:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, nzimmer@sgi.com

Subject: + rbtree-remove-unneeded-include.patch added to -mm tree
To: nzimmer@sgi.com,dan.carpenter@oracle.com
From: akpm@linux-foundation.org
Date: Tue, 14 May 2013 12:32:06 -0700


The patch titled
     Subject: rbtree: remove unneeded include
has been added to the -mm tree.  Its filename is
     rbtree-remove-unneeded-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: rbtree: remove unneeded include

Remove an unnecessary include to kernel.h

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/rbtree.h~rbtree-remove-unneeded-include include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-remove-unneeded-include
+++ a/include/linux/rbtree.h
@@ -29,7 +29,6 @@
 #ifndef	_LINUX_RBTREE_H
 #define	_LINUX_RBTREE_H
 
-#include <linux/kernel.h>
 #include <linux/stddef.h>
 
 struct rb_node {
_

Patches currently in -mm which might be from nzimmer@sgi.com are

rbtree-remove-unneeded-include.patch

