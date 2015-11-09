From: akpm@linux-foundation.org
Subject: [merged]
 get_maintainer-add-missing-documentation-for-git-blame-signatures.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 11:46:04 -0800
Message-ID: <5640f7fc.X1PLMsne0p+zErjA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbbKITqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:46:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: computersforpeace@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: add missing documentation for --git-blame-signatures
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-missing-documentation-for-git-blame-signatures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Brian Norris <computersforpeace@gmail.com>
Subject: get_maintainer: add missing documentation for --git-blame-signatures

I really haven't used this option much myself, so feel free to improve on
the documentation for it.  I just noticed it while inspecting this script
for undocumented features.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/get_maintainer.pl~get_maintainer-add-missing-documentation-for-git-blame-signatures scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-add-missing-documentation-for-git-blame-signatures
+++ a/scripts/get_maintainer.pl
@@ -781,6 +781,7 @@ MAINTAINER field selection options:
     --git-max-maintainers => maximum maintainers to add (default: $email_git_max_maintainers)
     --git-min-percent => minimum percentage of commits required (default: $email_git_min_percent)
     --git-blame => use git blame to find modified commits for patch or file
+    --git-blame-signatures => when used with --git-blame, also include all commit signers
     --git-since => git history to use (default: $email_git_since)
     --hg-since => hg history to use (default: $email_hg_since)
     --interactive => display a menu (mostly useful if used with the --git option)
_

Patches currently in -mm which might be from computersforpeace@gmail.com are


