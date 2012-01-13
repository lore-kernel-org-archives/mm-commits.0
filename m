From: akpm@linux-foundation.org
Subject: [merged] documentation-cgroups-memorytxt-fix-typo.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:24 -0800
Message-ID: <20120113203324.94D8C10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51298 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097Ab2AMUdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:25 -0500
Received: by mail-gy0-f202.google.com with SMTP id r18so207082ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhu.yanhai@gmail.com, gaoyang.zyh@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/cgroups/memory.txt: fix typo
has been removed from the -mm tree.  Its filename was
     documentation-cgroups-memorytxt-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Documentation/cgroups/memory.txt: fix typo

It should be memsw.max_usage_in_bytes. This typo has been there for
really a long time.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~documentation-cgroups-memorytxt-fix-typo Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~documentation-cgroups-memorytxt-fix-typo
+++ a/Documentation/cgroups/memory.txt
@@ -61,7 +61,7 @@ Brief summary of control files.
  memory.failcnt			 # show the number of memory usage hits limits
  memory.memsw.failcnt		 # show the number of memory+Swap hits limits
  memory.max_usage_in_bytes	 # show max memory usage recorded
- memory.memsw.usage_in_bytes	 # show max memory+Swap usage recorded
+ memory.memsw.max_usage_in_bytes # show max memory+Swap usage recorded
  memory.soft_limit_in_bytes	 # set/show soft limit of memory usage
  memory.stat			 # show various statistics
  memory.use_hierarchy		 # set/show hierarchical account enabled
_

Patches currently in -mm which might be from zhu.yanhai@gmail.com are

origin.patch

