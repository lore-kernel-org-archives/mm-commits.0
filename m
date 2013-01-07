From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-arch-lib-perf_eventc.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:43 -0800
Message-ID: <20130107192644.3F16C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:61869 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3AGT0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:46 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so1261745eaa.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, a.p.zijlstra@chello.nl, acme@ghostprotocols.net, mingo@redhat.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove arch/*/lib/perf_event*.c
has been removed from the -mm tree.  Its filename was
     maintainers-remove-arch-lib-perf_eventc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove arch/*/lib/perf_event*.c

This pattern only matched arch/frv/lib/perf_event.c, which was removed by
commit e360adb ("irq_work: Add generic hardirq context callbacks").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-arch-lib-perf_eventc MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arch-lib-perf_eventc
+++ a/MAINTAINERS
@@ -5855,7 +5855,6 @@ F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
 F:	arch/*/kernel/*/*/perf_event*.c
 F:	arch/*/include/asm/perf_event.h
-F:	arch/*/lib/perf_event*.c
 F:	arch/*/kernel/perf_callchain.c
 F:	tools/perf/
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

