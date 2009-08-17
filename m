From: akpm@linux-foundation.org
Subject: + reporting-bugs-add-get_maintainerpl-blurb.patch added to -mm tree
Date: Mon, 17 Aug 2009 15:42:25 -0700
Message-ID: <200908172242.n7HMgPt6000639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbZHQWm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 18:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     REPORTING-BUGS: add get_maintainer.pl blurb
has been added to the -mm tree.  Its filename is
     reporting-bugs-add-get_maintainerpl-blurb.patch

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
Subject: REPORTING-BUGS: add get_maintainer.pl blurb
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 REPORTING-BUGS |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN REPORTING-BUGS~reporting-bugs-add-get_maintainerpl-blurb REPORTING-BUGS
--- a/REPORTING-BUGS~reporting-bugs-add-get_maintainerpl-blurb
+++ a/REPORTING-BUGS
@@ -15,7 +15,10 @@ worry too much about getting the wrong p
 to the person responsible for the code relevant to what you were doing.
 If it occurs repeatably try and describe how to recreate it. That is
 worth even more than the oops itself.  The list of maintainers and
-mailing lists is in the MAINTAINERS file in this directory.
+mailing lists is in the MAINTAINERS file in this directory.  If you
+know the file name that causes the problem you can use the following
+command in this directory to find some of the maintainers of that file:
+     perl scripts/get_maintainer.pl -f <filename>
 
       If it is a security bug, please copy the Security Contact listed
 in the MAINTAINERS file.  They can help coordinate bugfix and disclosure.
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-osd-library-and-filesystem-pattern-fix.patch
reporting-bugs-add-get_maintainerpl-blurb.patch
linux-next.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-git-blame.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch
scripts-get_maintainerpl-add-pattern-depth.patch
scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch
scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch
scripts-get_maintainerpl-using-separator-implies-nomultiline.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

