From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-better-email-name-quoting.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:15 -0700
Message-ID: <200906171838.n5HIcFdg004298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758434AbZFQSqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: better email name quoting
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-better-email-name-quoting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: better email name quoting
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-better-email-name-quoting scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-better-email-name-quoting
+++ a/scripts/get_maintainer.pl
@@ -356,6 +356,7 @@ sub format_email {
     my ($name, $email) = @_;
 
     $name =~ s/^\s+|\s+$//g;
+    $name =~ s/^\"|\"$//g;
     $email =~ s/^\s+|\s+$//g;
 
     my $formatted_email = "";
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

