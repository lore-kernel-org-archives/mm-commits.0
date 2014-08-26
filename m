From: akpm@linux-foundation.org
Subject: + checkpatch-remove-debugging-message.patch added to -mm tree
Date: Tue, 26 Aug 2014 13:58:52 -0700
Message-ID: <53fcf50c.Wq5+VHxEBvaAt7RF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:60474 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaHZU6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 16:58:53 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so1759261iec.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 13:58:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove debugging message
has been added to the -mm tree.  Its filename is
     checkpatch-remove-debugging-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-remove-debugging-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-remove-debugging-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3749,7 +3749,6 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited before that close parenthesis ')'\n" . $herecurr) &&
 			    $fix) {
-				print("fixlinenr: <$fixlinenr> fixed[fixlinenr]: <$fixed[$fixlinenr]>\n");
 				$fixed[$fixlinenr] =~
 				    s/\s+\)/\)/;
 			}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-relax-check-for-length-of-git-commit-ids.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-spello.patch
checkpatch-remove-debugging-message.patch
ipc-always-handle-a-new-value-of-auto_msgmni.patch
linux-next.patch

