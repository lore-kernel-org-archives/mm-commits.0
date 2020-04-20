From: akpm@linux-foundation.org
Subject: +
 tools-testing-selftests-vm-remove-duplicate-headers.patch added to -mm tree
Date: Mon, 20 Apr 2020 15:36:07 -0700
Message-ID: <20200420223607.8K7wRBnPt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgDTWgI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgeffon@google.com, jagdsh.linux@gmail.com, mm-commits@vger.kernel.org, shuah@kernel.org


The patch titled
     Subject: tools/testing/selftests/vm: remove duplicate headers
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-vm-remove-duplicate-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-testing-selftests-vm-remove-duplicate-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-selftests-vm-remove-duplicate-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-testing-selftests-vm-remove-duplicate-headers.patch
