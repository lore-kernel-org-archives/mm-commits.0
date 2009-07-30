From: akpm@linux-foundation.org
Subject: [merged] get_maintainerpl-add-git-min-percent-option-fix.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:14 -0700
Message-ID: <200907302038.n6UKcEwL012757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbZG3Uip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     get_maintainerpl-add-git-min-percent-option-fix
has been removed from the -mm tree.  Its filename was
     get_maintainerpl-add-git-min-percent-option-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_maintainerpl-add-git-min-percent-option-fix
From: Joe Perches <joe@perches.com>

Allow an option to control the minimum percentage of sign-offs required
before being considered a maintainer.

git-min-percent has a default value of 5

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-add-git-min-percent-option-fix scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-add-git-min-percent-option-fix
+++ a/scripts/get_maintainer.pl
@@ -309,7 +309,7 @@ MAINTAINER field selection options:
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
-    --git-min-percent => minimum percentage of commits required (default: 0)
+    --git-min-percent => minimum percentage of commits required (default: 5)
     --git-since => git history to use (default: 1-year-ago)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch

