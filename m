From: akpm@linux-foundation.org
Subject: [merged] cgroups-remove-duplicate-include.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:35:43 -0400
Message-ID: <201003261936.o2QJag7f016542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab0CZTgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:36:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: remove duplicate include
has been removed from the -mm tree.  Its filename was
     cgroups-remove-duplicate-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: remove duplicate include
From: Li Zefan <lizf@cn.fujitsu.com>

commit e6a1105b ("cgroups: subsystem module loading interface") and commit
c50cc752 ("sched, cgroups: Fix module export") result in duplicate
including of module.h

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-remove-duplicate-include kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-remove-duplicate-include
+++ a/kernel/cgroup.c
@@ -27,7 +27,6 @@
  */
 
 #include <linux/cgroup.h>
-#include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch

