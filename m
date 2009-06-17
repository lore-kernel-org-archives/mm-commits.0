From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:21 -0700
Message-ID: <200906171838.n5HIcLjw004440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759452AbZFQSqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: allow 8 bit characters in email addresses
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: allow 8 bit characters in email addresses
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses
+++ a/scripts/get_maintainer.pl
@@ -57,7 +57,7 @@ my $penguin_chiefs = "\(" . join("|",@pe
 
 # rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
-my $rfc822_char = '[\\000-\\177]';
+my $rfc822_char = '[\\000-\\377]';
 
 if (!GetOptions(
 		'email!' => \$email,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

