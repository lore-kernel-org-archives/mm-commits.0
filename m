From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch added to -mm tree
Date: Tue, 26 May 2009 14:41:47 -0700
Message-ID: <200905262141.n4QLflYi029600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758574AbZEZVmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: better fix for subscriber-only mailing lists
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch

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

maintainers-pair-edac-e752x-p-and-m-entries.patch
linux-next.patch
scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers.patch
scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch
scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering.patch
scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch
scripts-get_maintainerpl-support-m-lines-with-names-and-multiple-entries-per-m-line.patch
scripts-get_maintainerpl-better-email-name-quoting.patch
scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines.patch
scripts-get_maintainerpl-dont-print-maintainers-when-not-requested.patch
scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses.patch
scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch.patch
maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries.patch
maintainers-add-file-patterns-to-the-rest.patch
maintainers-update-m32r-file-patterns-after-rename.patch
maintainers-mark-alsa-lists-as-moderated.patch
maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch
maintainers-mention-scripts-get_maintainerpl-in-the-preface.patch
maintainers-add-file-pattern-to-cisco-fcoe-hba-driver.patch

