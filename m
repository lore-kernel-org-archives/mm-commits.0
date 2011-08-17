From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-update-linuss-git-repository.patch added to -mm tree
Date: Wed, 17 Aug 2011 14:23:22 -0700
Message-ID: <201108172123.p7HLNMM6029155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab1HQVX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 17:23:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf.thielow@googlemail.com, joe@perches.com


The patch titled
     scripts/get_maintainer.pl: update Linus's git repository
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-update-linuss-git-repository.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: update Linus's git repository
From: Ralf Thielow <ralf.thielow@googlemail.com>

Change to new git tree -
(git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git).

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-update-linuss-git-repository scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-update-linuss-git-repository
+++ a/scripts/get_maintainer.pl
@@ -1389,7 +1389,7 @@ sub vcs_exists {
 	warn("$P: No supported VCS found.  Add --nogit to options?\n");
 	warn("Using a git repository produces better results.\n");
 	warn("Try Linus Torvalds' latest git repository using:\n");
-	warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git\n");
 	$printed_novcs = 1;
     }
     return 0;
_

Patches currently in -mm which might be from ralf.thielow@googlemail.com are

scripts-get_maintainerpl-update-linuss-git-repository.patch

