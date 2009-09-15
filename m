From: akpm@linux-foundation.org
Subject: + maintainers-integrate-p-m-lines.patch added to -mm tree
Date: Tue, 15 Sep 2009 15:13:40 -0700
Message-ID: <200909152213.n8FMDemY003817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbZIOWNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Sep 2009 18:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, anil_ravindranath@pmc-sierra.com, kalle.valo@nokia.com


The patch titled
     MAINTAINERS: integrate P:/M: lines
has been added to the -mm tree.  Its filename is
     maintainers-integrate-p-m-lines.patch

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
Subject: MAINTAINERS: integrate P:/M: lines
From: Joe Perches <joe@perches.com>

A couple of new uses of separate "P: name" "M: address" lines are
converted to single line "M: name <address>"

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-integrate-p-m-lines MAINTAINERS
--- a/MAINTAINERS~maintainers-integrate-p-m-lines
+++ a/MAINTAINERS
@@ -4059,8 +4059,7 @@ F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
 
 PMC SIERRA MaxRAID DRIVER
-P:	Anil Ravindranath
-M:	anil_ravindranath@pmc-sierra.com
+M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.pmc-sierra.com/
 S:	Supported
@@ -5703,8 +5702,7 @@ S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
 WL1251 WIRELESS DRIVER
-P:	Kalle Valo
-M:	kalle.valo@nokia.com
+M:	Kalle Valo <kalle.valo@nokia.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-git-blame.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch
scripts-get_maintainerpl-add-pattern-depth.patch
scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch
scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch
scripts-get_maintainerpl-using-separator-implies-nomultiline.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
scripts-get_maintainerpl-add-maintainers-in-order-listed-in-matched-section.patch
maintainers-acpi-add-include-acpi.patch
maintainers-omap-fix-regex.patch
maintainers-integrate-p-m-lines.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
ncpfs-remove-dead-url-from-documentation.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

