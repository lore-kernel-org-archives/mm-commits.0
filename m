From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-txt-maintainer-list-and-source-repo-path.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:04:50 -0700
Message-ID: <20120918190450.B72E41E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33403 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2IRTEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:04:51 -0400
Received: by ggnu1 with SMTP id u1so27199ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:04:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.wei@intel.com, hpa@zytor.com, mingo@elte.hu, richard.l.maliszewski@intel.com, shane.wang@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix TXT maintainer list and source repo path
has been removed from the -mm tree.  Its filename was
     maintainers-fix-txt-maintainer-list-and-source-repo-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

