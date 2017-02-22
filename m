From: akpm@linux-foundation.org
Subject: [folded-merged]
 scripts-spellingtxt-fix-incorrect-typo-words-fix.patch removed from -mm
 tree
Date: Wed, 22 Feb 2017 15:13:04 -0800
Message-ID: <58ae1b00.qUoC6ORWoMabFs5j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932924AbdBVXO3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:14:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-spellingtxt-fix-incorrect-typo-words-fix
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-fix-incorrect-typo-words-fix.patch

This patch was dropped because it was folded into scripts-spellingtxt-fix-incorrect-typo-words.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts-spellingtxt-fix-incorrect-typo-words-fix

"licencing" is valid British spelling and should be kept, per Joe

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/spelling.txt~scripts-spellingtxt-fix-incorrect-typo-words-fix scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-fix-incorrect-typo-words-fix
+++ a/scripts/spelling.txt
@@ -604,7 +604,7 @@ libaries||libraries
 libary||library
 librairies||libraries
 libraris||libraries
-licenceing||licensing
+licenceing||licencing
 loggging||logging
 loggin||login
 logile||logfile
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-spellingtxt-fix-incorrect-typo-words.patch
slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch

