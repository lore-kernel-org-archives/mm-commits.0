From: akpm@linux-foundation.org
Subject: [withdrawn] rbtree-remove-unneeded-include.patch removed from -mm tree
Date: Mon, 01 Jul 2013 13:09:42 -0700
Message-ID: <51d1e206.R71xqL/wF7uLLWEz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3GAUJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 16:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, nzimmer@sgi.com

Subject: [withdrawn] rbtree-remove-unneeded-include.patch removed from -mm tree
To: nzimmer@sgi.com,dan.carpenter@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 13:09:42 -0700


The patch titled
     Subject: rbtree: remove unneeded include
has been removed from the -mm tree.  Its filename was
     rbtree-remove-unneeded-include.patch

This patch was dropped because it was withdrawn

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

linux-next.patch
rbtree-remove-unneeded-include-fix.patch

