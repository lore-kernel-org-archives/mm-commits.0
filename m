From: akpm@linux-foundation.org
Subject: + maintainers-fix-txt-maintainer-list-and-source-repo-path.patch added to -mm tree
Date: Fri, 31 Aug 2012 12:56:57 -0700
Message-ID: <20120831195658.3838720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44615 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2HaT5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 15:57:01 -0400
Received: by wibhr14 with SMTP id hr14so85194wib.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 12:56:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gang.wei@intel.com, hpa@zytor.com, mingo@elte.hu, richard.l.maliszewski@intel.com, shane.wang@intel.com, tglx@linutronix.de


The patch titled
     Subject: MAINTAINERS: fix TXT maintainer list and source repo path
has been added to the -mm tree.  Its filename is
     maintainers-fix-txt-maintainer-list-and-source-repo-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang Wei <gang.wei@intel.com>
Subject: MAINTAINERS: fix TXT maintainer list and source repo path

Signed-off-by: Gang Wei <gang.wei@intel.com>
Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>
Cc: Gang Wei <gang.wei@intel.com>
Cc: Shane Wang <shane.wang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-txt-maintainer-list-and-source-repo-path MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-txt-maintainer-list-and-source-repo-path
+++ a/MAINTAINERS
@@ -3666,11 +3666,12 @@ F:	Documentation/networking/README.ipw22
 F:	drivers/net/wireless/ipw2x00/
 
 INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)
-M:	Joseph Cihula <joseph.cihula@intel.com>
+M:	Richard L Maliszewski <richard.l.maliszewski@intel.com>
+M:	Gang Wei <gang.wei@intel.com>
 M:	Shane Wang <shane.wang@intel.com>
 L:	tboot-devel@lists.sourceforge.net
 W:	http://tboot.sourceforge.net
-T:	Mercurial http://www.bughost.org/repos.hg/tboot.hg
+T:	hg http://tboot.hg.sourceforge.net:8000/hgroot/tboot/tboot
 S:	Supported
 F:	Documentation/intel_txt.txt
 F:	include/linux/tboot.h
_

Patches currently in -mm which might be from gang.wei@intel.com are

maintainers-fix-txt-maintainer-list-and-source-repo-path.patch

