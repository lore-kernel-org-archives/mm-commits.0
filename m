From: akpm@linux-foundation.org
Subject: [merged] maintainers-integrate-p-m-lines.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:23 -0700
Message-ID: <200909222045.n8MKjNOq015586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbZIVUpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, anil_ravindranath@pmc-sierra.com, kalle.valo@nokia.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: integrate P:/M: lines
has been removed from the -mm tree.  Its filename was
     maintainers-integrate-p-m-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4028,8 +4028,7 @@ F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
 
 PMC SIERRA MaxRAID DRIVER
-P:	Anil Ravindranath
-M:	anil_ravindranath@pmc-sierra.com
+M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.pmc-sierra.com/
 S:	Supported
@@ -5660,8 +5659,7 @@ S:	Maintained
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
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
ncpfs-remove-dead-url-from-documentation.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

