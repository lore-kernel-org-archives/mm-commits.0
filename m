From: akpm@linux-foundation.org
Subject: [merged] uapi-fix-tools-vm-page-typesc.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:07 -0700
Message-ID: <20121029195007.BEAF31E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35064 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2J2TuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:09 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so682391vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dshadowwolf@gmail.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: UAPI: fix tools/vm/page-types.c
has been removed from the -mm tree.  Its filename was
     uapi-fix-tools-vm-page-typesc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: UAPI: fix tools/vm/page-types.c

Fix tools/vm/page-types.c to use the UAPI variant of linux/kernel-page-flags.h
lest the following error appear:

	In file included from page-types.c:38:0:
	../../include/linux/kernel-page-flags.h:4:42: fatal error:
	uapi/linux/kernel-page-flags.h: No such file or directory

Reported-by: Daniel Hazelton <dshadowwolf@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Daniel Hazelton <dshadowwolf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/vm/page-types.c~uapi-fix-tools-vm-page-typesc tools/vm/page-types.c
--- a/tools/vm/page-types.c~uapi-fix-tools-vm-page-typesc
+++ a/tools/vm/page-types.c
@@ -35,7 +35,7 @@
 #include <sys/mount.h>
 #include <sys/statfs.h>
 #include "../../include/uapi/linux/magic.h"
-#include "../../include/linux/kernel-page-flags.h"
+#include "../../include/uapi/linux/kernel-page-flags.h"
 
 
 #ifndef MAX_PATH
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

