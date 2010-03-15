From: akpm@linux-foundation.org
Subject: [merged] memcg-update-maintainer-list.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:20 -0400
Message-ID: <201003150700.o2F70rJq016664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935761Ab0COHBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: update maintainer list
has been removed from the -mm tree.  Its filename was
     memcg-update-maintainer-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: update maintainer list
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Nishimura-san have been working for memcg very good.  His review and tests
give us much improvements and account migraiton which he is now
challenging is really important.

He is a stakeholder.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~memcg-update-maintainer-list MAINTAINERS
--- a/MAINTAINERS~memcg-update-maintainer-list
+++ a/MAINTAINERS
@@ -3628,7 +3628,7 @@ F:	mm/
 
 MEMORY RESOURCE CONTROLLER
 M:	Balbir Singh <balbir@linux.vnet.ibm.com>
-M:	Pavel Emelyanov <xemul@openvz.org>
+M:	Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
 M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch

