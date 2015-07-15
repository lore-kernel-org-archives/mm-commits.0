From: akpm@linux-foundation.org
Subject: + namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch
 added to -mm tree
Date: Wed, 15 Jul 2015 13:59:29 -0700
Message-ID: <55a6c9b1.8D1dMt/KpvA02jTn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbbGOU73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 16:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: namei: fix warning while make xmldocs caused by namei.c
has been added to the -mm tree.  Its filename is
     namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2484,7 +2484,7 @@ done:
 
 /**
  * path_mountpoint - look up a path to be umounted
- * @nameidata:	lookup context
+ * @nd:		lookup context
  * @flags:	lookup flags
  * @path:	pointer to container for result
  *
_

Patches currently in -mm which might be from standby24x7@gmail.com are

origin.patch
linux-next.patch
namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch

