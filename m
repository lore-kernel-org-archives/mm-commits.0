From: akpm@linux-foundation.org
Subject: [merged]
 tools-testing-selftests-vm-remove-duplicate-headers.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:21:15 -0700
Message-ID: <20200605202115.DPU506h8Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgFEUVP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgeffon@google.com, jagdsh.linux@gmail.com, mm-commits@vger.kernel.org, shuah@kernel.org


The patch titled
     Subject: tools/testing/selftests/vm: remove duplicate headers
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-vm-remove-duplicate-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jagadeesh Pagadala <jagdsh.linux@gmail.com>
Subject: tools/testing/selftests/vm: remove duplicate headers

Code cleanup: Remove duplicate headers which are included twice.

Link: http://lkml.kernel.org/r/1587278984-18847-1-git-send-email-jagdsh.linux@gmail.com
Signed-off-by: Jagadeesh Pagadala <jagdsh.linux@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_dontunmap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/mremap_dontunmap.c~tools-testing-selftests-vm-remove-duplicate-headers
+++ a/tools/testing/selftests/vm/mremap_dontunmap.c
@@ -11,7 +11,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <stdlib.h>
 #include <unistd.h>
 
 #include "../kselftest.h"
_

Patches currently in -mm which might be from jagdsh.linux@gmail.com are
