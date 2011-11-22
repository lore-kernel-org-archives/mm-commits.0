From: akpm@linux-foundation.org
Subject: + documentation-cgroups-memorytxt-fix-typo.patch added to -mm tree
Date: Tue, 22 Nov 2011 12:14:16 -0800
Message-ID: <201111222014.pAMKEGU9013087@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:53997 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1KVUOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 15:14:19 -0500
Received: by yenm12 with SMTP id m12so120211yen.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 12:14:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhu.yanhai@gmail.com, gaoyang.zyh@taobao.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: Documentation/cgroups/memory.txt: fix typo
has been added to the -mm tree.  Its filename is
     documentation-cgroups-memorytxt-fix-typo.patch

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
Subject: Subject: Documentation/cgroups/memory.txt: fix typo

Patches currently in -mm which might be from zhu.yanhai@gmail.com are

documentation-cgroups-memorytxt-fix-typo.patch

