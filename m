From: akpm@linux-foundation.org
Subject: [merged] autofs-drop-unnecessary-extern-in-autofs_ih.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:37 -0700
Message-ID: <57fe8db9.9AqUaWOG8xi05TBJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33193 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755880AbcJLTYd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: drop unnecessary extern in autofs_i.h
has been removed from the -mm tree.  Its filename was
     autofs-drop-unnecessary-extern-in-autofs_ih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: drop unnecessary extern in autofs_i.h

autofs4_kill_sb() doesn't need to be declared as extern, and no other
functions in .h are explicitly declared as extern.

Link: http://lkml.kernel.org/r/20160812024739.12352.99354.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/autofs_i.h~autofs-drop-unnecessary-extern-in-autofs_ih fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-drop-unnecessary-extern-in-autofs_ih
+++ a/fs/autofs4/autofs_i.h
@@ -271,4 +271,4 @@ static inline void autofs4_del_expiring(
 	}
 }
 
-extern void autofs4_kill_sb(struct super_block *);
+void autofs4_kill_sb(struct super_block *);
_

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are


