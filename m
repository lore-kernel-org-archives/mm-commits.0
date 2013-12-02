From: akpm@linux-foundation.org
Subject: [merged]
 documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch removed from -mm tree
Date: Mon, 02 Dec 2013 12:37:26 -0800
Message-ID: <529cef86.yd3mCJmFfGQeOH8h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3LBUh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 15:37:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org, peterz@infradead.org, mingo@kernel.org, nicolas.dichtel@6wind.com

Subject: [merged] documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch removed from -mm tree
To: nicolas.dichtel@6wind.com,mingo@kernel.org,peterz@infradead.org,rdunlap@infradead.org,rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 12:37:26 -0800


The patch titled
     Subject: Documentation/DocBook/device-drivers.tmpl: fix generation of device-drivers
has been removed from the -mm tree.  Its filename was
     documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Documentation/DocBook/device-drivers.tmpl: fix generation of device-drivers

Since commit 7a6354e241d8 ("sched: Move wait.c into kernel/sched/"), the path
of this file has changed.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/device-drivers.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/device-drivers.tmpl~documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers Documentation/DocBook/device-drivers.tmpl
--- a/Documentation/DocBook/device-drivers.tmpl~documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers
+++ a/Documentation/DocBook/device-drivers.tmpl
@@ -58,7 +58,7 @@
      </sect1>
      <sect1><title>Wait queues and Wake events</title>
 !Iinclude/linux/wait.h
-!Ekernel/wait.c
+!Ekernel/sched/wait.c
      </sect1>
      <sect1><title>High-resolution timers</title>
 !Iinclude/linux/ktime.h
_

Patches currently in -mm which might be from nicolas.dichtel@6wind.com are

origin.patch
linux-next.patch

