From: akpm@linux-foundation.org
Subject: [merged] perf-fix-duplicate-header-inclusion.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:26 -0700
Message-ID: <20121011205926.A3CA3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62654 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198Ab2JKU71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:27 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so251836vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, adrian.hunter@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: perf: fix duplicate header inclusion
has been removed from the -mm tree.  Its filename was
     perf-fix-duplicate-header-inclusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: perf: fix duplicate header inclusion

#include <stdbool.h> somehow got duplicated on its way to linus's tree
(probably as a conflict resolution as things got sent through multiple trees)

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/perf/util/include/linux/rbtree.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN tools/perf/util/include/linux/rbtree.h~perf-fix-duplicate-header-inclusion tools/perf/util/include/linux/rbtree.h
--- a/tools/perf/util/include/linux/rbtree.h~perf-fix-duplicate-header-inclusion
+++ a/tools/perf/util/include/linux/rbtree.h
@@ -1,3 +1,2 @@
 #include <stdbool.h>
-#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
_

Patches currently in -mm which might be from walken@google.com are

origin.patch

