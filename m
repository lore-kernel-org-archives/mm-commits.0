From: akpm@linux-foundation.org
Subject: [merged] mm-fix-cleancache-debugfs-directory-path.patch removed
 from -mm tree
Date: Wed, 21 Jan 2015 13:42:33 -0800
Message-ID: <54c01d49.c7SS1xhb06ljdwvP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbAUVme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jan 2015 16:42:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.jabrzyk@samsung.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix cleancache debugfs directory path
has been removed from the -mm tree.  Its filename was
     mm-fix-cleancache-debugfs-directory-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Subject: mm: fix cleancache debugfs directory path

Minor fixes for cleancache about wrong debugfs paths in documentation and
code comment.

Signed-off-by: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/cleancache.txt |    2 +-
 mm/cleancache.c                 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/cleancache.txt~mm-fix-cleancache-debugfs-directory-path Documentation/vm/cleancache.txt
--- a/Documentation/vm/cleancache.txt~mm-fix-cleancache-debugfs-directory-path
+++ a/Documentation/vm/cleancache.txt
@@ -85,7 +85,7 @@ lock the page to ensure serial behavior.
 CLEANCACHE PERFORMANCE METRICS
 
 If properly configured, monitoring of cleancache is done via debugfs in
-the /sys/kernel/debug/mm/cleancache directory.  The effectiveness of cleancache
+the /sys/kernel/debug/cleancache directory.  The effectiveness of cleancache
 can be measured (across all filesystems) with:
 
 succ_gets	- number of gets that were successful
diff -puN mm/cleancache.c~mm-fix-cleancache-debugfs-directory-path mm/cleancache.c
--- a/mm/cleancache.c~mm-fix-cleancache-debugfs-directory-path
+++ a/mm/cleancache.c
@@ -25,7 +25,7 @@
 static struct cleancache_ops *cleancache_ops __read_mostly;
 
 /*
- * Counters available via /sys/kernel/debug/frontswap (if debugfs is
+ * Counters available via /sys/kernel/debug/cleancache (if debugfs is
  * properly configured.  These are for information only so are not protected
  * against increment races.
  */
_

Patches currently in -mm which might be from m.jabrzyk@samsung.com are

linux-next.patch

