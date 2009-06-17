From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:23 -0700
Message-ID: <200906171838.n5HIcNf1004460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757380AbZFQSjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: change "die" to "warn" when command line file is not a patch
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: change "die" to "warn" when command line file is not a patch
From: Joe Perches <joe@perches.com>

fixes git send-email with a cover letter

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch
+++ a/scripts/get_maintainer.pl
@@ -165,7 +165,7 @@ foreach my $file (@ARGV) {
 	}
 	close(PATCH);
 	if ($file_cnt == @files) {
-	    die "$P: file '${file}' doesn't appear to be a patch.  "
+	    warn "$P: file '${file}' doesn't appear to be a patch.  "
 		. "Add -f to options?\n";
 	}
 	@files = sort_and_uniq(@files);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

