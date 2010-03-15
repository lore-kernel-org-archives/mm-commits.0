From: akpm@linux-foundation.org
Subject: + cgroups-remove-duplicate-include.patch added to -mm tree
Date: Mon, 15 Mar 2010 13:48:05 -0700
Message-ID: <201003152048.o2FKm5cc021722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252Ab0COUsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 16:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: remove duplicate include
has been added to the -mm tree.  Its filename is
     cgroups-remove-duplicate-include.patch

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
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
cgroups-remove-duplicate-include.patch
cgroups-net_cls-as-module.patch
sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path.patch

