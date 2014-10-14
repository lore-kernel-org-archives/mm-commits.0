From: akpm@linux-foundation.org
Subject: [merged] checkpatch-remove-debugging-message.patch removed from
 -mm tree
Date: Tue, 14 Oct 2014 11:19:35 -0700
Message-ID: <543d6937.agP+o1fy6eZpljsx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbaJNSTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove debugging message
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-debugging-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: remove debugging message

An unnecessary --fix debugging left-over is removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 -
 1 file changed, 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-debugging-message scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-debugging-message
+++ a/scripts/checkpatch.pl
@@ -3752,7 +3752,6 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited before that close parenthesis ')'\n" . $herecurr) &&
 			    $fix) {
-				print("fixlinenr: <$fixlinenr> fixed[fixlinenr]: <$fixed[$fixlinenr]>\n");
 				$fixed[$fixlinenr] =~
 				    s/\s+\)/\)/;
 			}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

