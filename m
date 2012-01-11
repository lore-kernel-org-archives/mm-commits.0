From: akpm@linux-foundation.org
Subject: + init-kconfig-fix-dependency-for-cgroup_sched.patch added to -mm tree
Date: Wed, 11 Jan 2012 14:53:33 -0800
Message-ID: <20120111225334.1DB8C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:58999 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2AKWxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 17:53:37 -0500
Received: by eaad12 with SMTP id d12so34410eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 14:53:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: festevam@gmail.com, a.p.zijlstra@chello.nl, fabio.estevam@freescale.com, mingo@elte.hu


The patch titled
     Subject: init/Kconfig: fix dependency for CGROUP_SCHED
has been added to the -mm tree.  Its filename is
     init-kconfig-fix-dependency-for-cgroup_sched.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabio Estevam <festevam@gmail.com>
Subject: init/Kconfig: fix dependency for CGROUP_SCHED

Fix the following build warning:

warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN init/Kconfig~init-kconfig-fix-dependency-for-cgroup_sched init/Kconfig
--- a/init/Kconfig~init-kconfig-fix-dependency-for-cgroup_sched
+++ a/init/Kconfig
@@ -713,7 +713,6 @@ config CGROUP_PERF
 
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
-	depends on EXPERIMENTAL
 	default n
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
_
Subject: Subject: init/Kconfig: fix dependency for CGROUP_SCHED

Patches currently in -mm which might be from festevam@gmail.com are

origin.patch
linux-next.patch
init-kconfig-fix-dependency-for-cgroup_sched.patch
include-linux-crash_dumph-needs-elfh.patch

