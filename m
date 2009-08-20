From: akpm@linux-foundation.org
Subject: [merged] maintainers-osd-library-and-filesystem-pattern-fix.patch removed from -mm tree
Date: Thu, 20 Aug 2009 13:12:38 -0700
Message-ID: <200908202012.n7KKCccM015264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755290AbZHTUNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 16:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bhalevy@panasas.com, bharrosh@panasas.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: OSD LIBRARY and FILESYSTEM pattern fix
has been removed from the -mm tree.  Its filename was
     maintainers-osd-library-and-filesystem-pattern-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: OSD LIBRARY and FILESYSTEM pattern fix
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-osd-library-and-filesystem-pattern-fix MAINTAINERS
--- a/MAINTAINERS~maintainers-osd-library-and-filesystem-pattern-fix
+++ a/MAINTAINERS
@@ -3804,7 +3804,7 @@ W:	http://open-osd.org
 T:	git git://git.open-osd.org/open-osd.git
 S:	Maintained
 F:	drivers/scsi/osd/
-F:	drivers/include/scsi/osd_*
+F:	include/scsi/osd_*
 F:	fs/exofs/
 
 P54 WIRELESS DRIVER
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
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

