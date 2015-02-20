From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-empty-package-initialization-script.patch added to -mm tree
Date: Fri, 20 Feb 2015 13:14:20 -0800
Message-ID: <54e7a3ac.uO9SEIPEJgsGkUEJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbbBTVOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 16:14:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add empty package initialization script
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-empty-package-initialization-script.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-empty-package-initialization-script.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-empty-package-initialization-script.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add empty package initialization script

This got lost during the initial merge process: Python requires an
__init__.py script, even if empty, in order to accept a directory as
package.  Add it, this time as a non-empty file.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/__init__.py |    1 +
 1 file changed, 1 insertion(+)

diff -puN /dev/null scripts/gdb/linux/__init__.py
--- /dev/null
+++ a/scripts/gdb/linux/__init__.py
@@ -0,0 +1 @@
+# nothing to do for the initialization of this package
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch
scripts-gdb-add-empty-package-initialization-script.patch

