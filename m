From: akpm@linux-foundation.org
Subject: + maintainers-osd-library-and-filesystem-pattern-fix.patch added to -mm tree
Date: Mon, 10 Aug 2009 21:10:16 -0700
Message-ID: <200908110410.n7B4AGMj015458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbZHKLzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bhalevy@panasas.com, bharrosh@panasas.com


The patch titled
     MAINTAINERS: OSD LIBRARY and FILESYSTEM pattern fix
has been added to the -mm tree.  Its filename is
     maintainers-osd-library-and-filesystem-pattern-fix.patch

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
@@ -3844,7 +3844,7 @@ W:	http://open-osd.org
 T:	git git://git.open-osd.org/open-osd.git
 S:	Maintained
 F:	drivers/scsi/osd/
-F:	drivers/include/scsi/osd_*
+F:	include/scsi/osd_*
 F:	fs/exofs/
 
 P54 WIRELESS DRIVER
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-osd-library-and-filesystem-pattern-fix.patch
linux-next.patch
maintainers-add-ipvs-include-files.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

