From: akpm@linux-foundation.org
Subject: +
 documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch added to -mm tree
Date: Fri, 22 Nov 2013 14:13:51 -0800
Message-ID: <528fd71f.yb7fm3tGZvn8L8lO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3KVWNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:13:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org, peterz@infradead.org, mingo@kernel.org, nicolas.dichtel@6wind.com

Subject: + documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch added to -mm tree
To: nicolas.dichtel@6wind.com,mingo@kernel.org,peterz@infradead.org,rdunlap@infradead.org,rob@landley.net
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:13:51 -0800


The patch titled
     Subject: Documentation/DocBook/device-drivers.tmpl: fix generation of device-drivers
has been added to the -mm tree.  Its filename is
     documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
documentation-docbook-device-driverstmpl-fix-generation-of-device-drivers.patch

