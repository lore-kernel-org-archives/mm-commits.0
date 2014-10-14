From: akpm@linux-foundation.org
Subject: [merged] checkpatch-remove-unnecessary-after-88.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:19:45 -0700
Message-ID: <543d6941.+DQ7jvcZKfbLGNX+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaJNSTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove unnecessary + after {8,8}
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-unnecessary-after-88.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: remove unnecessary + after {8,8}

There's a useless "+" use that needs to be removed as perl 5.20 emits a
"Useless use of greediness modifier '+'" message each time it's hit.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-unnecessary-after-88 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-unnecessary-after-88
+++ a/scripts/checkpatch.pl
@@ -2431,7 +2431,7 @@ sub process {
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
 				while ($fixed[$fixlinenr] =~
-					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
+					   s/(^\+.*) {8,8}\t/$1\t\t/) {}
 				while ($fixed[$fixlinenr] =~
 					   s/(^\+.*) +\t/$1\t/) {}
 			}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

