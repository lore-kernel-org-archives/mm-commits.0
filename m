From: akpm@linux-foundation.org
Subject: - memcg-fix-a-typo-in-kconfig.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:26 -0800
Message-ID: <200901082247.n08MlQNB026880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763509AbZAHWsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: fix a typo in Kconfig
has been removed from the -mm tree.  Its filename was
     memcg-fix-a-typo-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix a typo in Kconfig
From: Li Zefan <lizf@cn.fujitsu.com>

s/contoller/controller/

Signed-of-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~memcg-fix-a-typo-in-kconfig init/Kconfig
--- a/init/Kconfig~memcg-fix-a-typo-in-kconfig
+++ a/init/Kconfig
@@ -420,7 +420,7 @@ config CGROUP_MEM_RES_CTLR
 	  sure you need the memory resource controller. Even when you enable
 	  this, you can set "cgroup_disable=memory" at your boot option to
 	  disable memory resource controller and you can avoid overheads.
-	  (and lose benefits of memory resource contoller)
+	  (and lose benefits of memory resource controller)
 
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch

