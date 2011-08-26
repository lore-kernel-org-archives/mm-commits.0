From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-update-linuss-git-repository.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:26 -0700
Message-ID: <201108261903.p7QJ3AA7005660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab1HZTDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf.thielow@googlemail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: update Linus's git repository
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-update-linuss-git-repository.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

