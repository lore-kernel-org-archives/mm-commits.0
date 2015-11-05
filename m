From: akpm@linux-foundation.org
Subject: +
 get_maintainer-add-missing-documentation-for-git-blame-signatures.patch
 added to -mm tree
Date: Wed, 04 Nov 2015 17:32:00 -0800
Message-ID: <563ab190.myHxgJUsXVee3N7F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031510AbbKEBcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2015 20:32:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: computersforpeace@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: add missing documentation for --git-blame-signatures
has been added to the -mm tree.  Its filename is
     get_maintainer-add-missing-documentation-for-git-blame-signatures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-add-missing-documentation-for-git-blame-signatures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-add-missing-documentation-for-git-blame-signatures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

get_maintainer-add-missing-documentation-for-git-blame-signatures.patch
get_maintainer-its-pattern-depth-not-pattern-depth.patch
get_maintainer-add-no-foo-options-to-help.patch
get_maintainer-r-list-reviewer-is-on-by-default.patch

