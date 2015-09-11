From: akpm@linux-foundation.org
Subject: [merged]
 namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch removed from
 -mm tree
Date: Fri, 11 Sep 2015 11:13:44 -0700
Message-ID: <55f319d8.DJfnjiNILnJNLpd4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbbIKSNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: namei: fix warning while make xmldocs caused by namei.c
has been removed from the -mm tree.  Its filename was
     namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: namei: fix warning while make xmldocs caused by namei.c

Fix the following warnings:

Warning(.//fs/namei.c:2422): No description found for parameter 'nd'
Warning(.//fs/namei.c:2422): Excess function parameter 'nameidata'
description in 'path_mountpoint'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namei.c~namei-fix-warning-while-make-xmldocs-caused-by-nameic fs/namei.c
--- a/fs/namei.c~namei-fix-warning-while-make-xmldocs-caused-by-nameic
+++ a/fs/namei.c
@@ -2438,7 +2438,7 @@ done:
 
 /**
  * path_mountpoint - look up a path to be umounted
- * @nameidata:	lookup context
+ * @nd:		lookup context
  * @flags:	lookup flags
  * @path:	pointer to container for result
  *
_

Patches currently in -mm which might be from standby24x7@gmail.com are


