From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:08 -0700
Message-ID: <201105271956.p4RJuD2X017530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab1E0UOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add mm/page_cgroup.c into memcg subsystem
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add mm/page_cgroup.c into memcg subsystem
From: Namhyung Kim <namhyung@gmail.com>

AFAICS mm/page_cgroup.c is for memcg subsystem, but it was directed only
to generic cgroup maintainers.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-mm-page_cgroupc-into-memcg-subsystem MAINTAINERS
--- a/MAINTAINERS~maintainers-add-mm-page_cgroupc-into-memcg-subsystem
+++ a/MAINTAINERS
@@ -4145,6 +4145,7 @@ M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
+F:	mm/page_cgroup.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2@infradead.org>
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch

