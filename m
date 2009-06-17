From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:06 -0700
Message-ID: <200906171838.n5HIc6xP004128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760966AbZFQSjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: better fix for subscriber-only mailing lists
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: better fix for subscriber-only mailing lists
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists
+++ a/scripts/get_maintainer.pl
@@ -380,7 +380,7 @@ sub add_categories {
 		    $list_address = $1;
 		    $list_additional = $2;
 		}
-		if ($list_additional =~ m/\(subscribers-only\)/) {
+		if ($list_additional =~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
 			push(@list_to, $list_address);
 		    }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

