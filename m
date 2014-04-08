From: akpm@linux-foundation.org
Subject: [folded-merged]
 ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch removed from -mm tree
Date: Tue, 08 Apr 2014 16:00:13 -0700
Message-ID: <53447f7d.VueT4+pjcWUxwV2o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbaDHXAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 19:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com, akpm@linux-foundation.org

Subject: [folded-merged] ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,joe@perches.com,petr@vandrovec.name,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 16:00:13 -0700


The patch titled
     Subject: ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix
has been removed from the -mm tree.  Its filename was
     ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch

This patch was dropped because it was folded into ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix

Cc: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ncp_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ncpfs/ncp_fs.h~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix fs/ncpfs/ncp_fs.h
--- a/fs/ncpfs/ncp_fs.h~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix
+++ a/fs/ncpfs/ncp_fs.h
@@ -22,7 +22,7 @@
 
 #define ncp_dbg(level, fmt, ...)				\
 do {								\
-	if (level >= DEBUG_NCP)					\
+	if (level < DEBUG_NCP)					\
 		pr_debug(fmt, ##__VA_ARGS__);			\
 } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

