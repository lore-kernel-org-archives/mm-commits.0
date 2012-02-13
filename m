From: akpm@linux-foundation.org
Subject: + maintainers-update-mca-section.patch added to -mm tree
Date: Mon, 13 Feb 2012 14:36:47 -0800
Message-ID: <20120213223647.6325FA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:50823 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809Ab2BMWgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Feb 2012 17:36:50 -0500
Received: by lahl5 with SMTP id l5so174541lah.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 14:36:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, greg.pearson@hp.com


The patch titled
     Subject: MAINTAINERS: Update MCA section
has been added to the -mm tree.  Its filename is
     maintainers-update-mca-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: Update MCA section

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
@@ -4363,6 +4363,13 @@ T:	git git://git.monstr.eu/linux-2.6-mic
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
@@ -4384,14 +4391,6 @@ M:	Thomas Langer <thomas.langer@lantiq.c
 S:	Maintained
 F:	arch/mips/lantiq/*
 
-MISCELLANEOUS MCA-SUPPORT
-M:	James Bottomley <James.Bottomley@HansenPartnership.com>
-S:	Maintained
-F:	Documentation/ia64/mca.txt
-F:	Documentation/mca.txt
-F:	drivers/mca/
-F:	include/linux/mca*
