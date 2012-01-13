From: akpm@linux-foundation.org
Subject: [merged] init-kconfig-fix-dependency-for-cgroup_sched.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:17 -0800
Message-ID: <20120113203118.D16421E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:46655 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2AMUbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:20 -0500
Received: by yenl1 with SMTP id l1so71982yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: festevam@gmail.com, a.p.zijlstra@chello.nl, fabio.estevam@freescale.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: fix dependency for CGROUP_SCHED
has been removed from the -mm tree.  Its filename was
     init-kconfig-fix-dependency-for-cgroup_sched.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from festevam@gmail.com are

origin.patch
linux-next.patch

