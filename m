From: akpm@linux-foundation.org
Subject: + maintainers-changed-ltp-maintainership-responsibilities.patch added to -mm tree
Date: Mon, 08 Feb 2010 16:03:02 -0800
Message-ID: <201002090003.o19032Gc011287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573Ab0BIADe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 19:03:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: risrajak@linux.vnet.ibm.com, subrata@linux.vnet.ibm.com, vapier@gentoo.org, yanegomi@gmail.com


The patch titled
     MAINTAINERS: changed LTP maintainership responsibilities
has been added to the -mm tree.  Its filename is
     maintainers-changed-ltp-maintainership-responsibilities.patch

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
Subject: MAINTAINERS: changed LTP maintainership responsibilities
From: Rishikesh <risrajak@linux.vnet.ibm.com>

Change the LTP maintainer responsibities from 2010.

Ref: http://marc.info/?l=ltp-list&m=126502242912536&w=2

Signed-off-by : Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Garrett Cooper <yanegomi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-changed-ltp-maintainership-responsibilities MAINTAINERS
--- a/MAINTAINERS~maintainers-changed-ltp-maintainership-responsibilities
+++ a/MAINTAINERS
@@ -3472,8 +3472,10 @@ S:	Maintained
 F:	drivers/scsi/sym53c8xx_2/
 
 LTP (Linux Test Project)
-M:	Subrata Modak <subrata@linux.vnet.ibm.com>
-M:	Mike Frysinger <vapier@gentoo.org>
+M:	Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
+M:	Garrett Cooper <yanegomi@gmail.com>
+M:     Mike Frysinger <vapier@gentoo.org>
+M:     Subrata Modak <subrata@linux.vnet.ibm.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
_

Patches currently in -mm which might be from risrajak@linux.vnet.ibm.com are

maintainers-changed-ltp-maintainership-responsibilities.patch

