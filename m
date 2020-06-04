From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 126/127] tools/testing/selftests/vm: remove
 duplicate headers
Date: Thu, 04 Jun 2020 16:52:57 -0700
Message-ID: <20200604235257.NejwG34BT%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXw6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:52:58 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bgeffon@google.com, jagdsh.linux@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org, torvalds@linux-foundation.org

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
