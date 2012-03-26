From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-mca-section.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:40 -0700
Message-ID: <20120326192840.6FB03A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:41979 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2CZT2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:41 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so831226vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, greg.pearson@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update MCA section
has been removed from the -mm tree.  Its filename was
     maintainers-update-mca-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update MCA section

The MCA section included a file referring to Machine Check rather than
Microchannel.

Rename the section to spell out Microchannel and drop the bad file
reference.

Reported-by: Greg Pearson <greg.pearson@hp.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN MAINTAINERS~maintainers-update-mca-section MAINTAINERS
--- a/MAINTAINERS~maintainers-update-mca-section
+++ a/MAINTAINERS
@@ -4416,6 +4416,13 @@ T:	git git://git.monstr.eu/linux-2.6-mic
 S:	Supported
 F:	arch/microblaze/
 
+MICROCHANNEL ARCHITECTURE (MCA)
+M:	James Bottomley <James.Bottomley@HansenPartnership.com>
+S:	Maintained
+F:	Documentation/mca.txt
+F:	drivers/mca/
+F:	include/linux/mca*
+
 MICROTEK X6 SCANNER
 M:	Oliver Neukum <oliver@neukum.name>
 S:	Maintained
@@ -4431,14 +4438,6 @@ S:	Supported
 F:	Documentation/mips/
 F:	arch/mips/
 
-MISCELLANEOUS MCA-SUPPORT
-M:	James Bottomley <James.Bottomley@HansenPartnership.com>
-S:	Maintained
-F:	Documentation/ia64/mca.txt
-F:	Documentation/mca.txt
-F:	drivers/mca/
-F:	include/linux/mca*
