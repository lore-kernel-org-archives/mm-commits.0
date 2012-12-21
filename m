From: akpm@linux-foundation.org
Subject: + maintainers-remove-arch-lib-perf_eventc.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:37 -0800
Message-ID: <20121221215937.6E77682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:33863 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2LUV7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:38 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so526390vcd.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, a.p.zijlstra@chello.nl, acme@ghostprotocols.net, mingo@redhat.com, paulus@samba.org


The patch titled
     Subject: MAINTAINERS: remove arch/*/lib/perf_event*.c
has been added to the -mm tree.  Its filename is
     maintainers-remove-arch-lib-perf_eventc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5836,7 +5836,6 @@ F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
 F:	arch/*/kernel/*/*/perf_event*.c
 F:	arch/*/include/asm/perf_event.h
-F:	arch/*/lib/perf_event*.c
 F:	arch/*/kernel/perf_callchain.c
 F:	tools/perf/
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
maintainers-remove-drivers-platform-msm.patch
maintainers-remove-arch-arm-common-time-acornc.patch
maintainers-remove-arch-arm-plat-s5p.patch
maintainers-fix-drivers-rtc-rtc-vt8500c.patch
maintainers-fix-arch-arm-mach-at91-include-mach-at_hdmach.patch
maintainers-fix-drivers-media-platform-atmel-isic.patch
maintainers-adjust-for-uapi.patch
maintainers-fix-drivers-media-usb-dvb-usb-cxusb.patch
maintainers-remove-drivers-video-epson1355fbc.patch
maintainers-fix-plat-mxc-include-mach-imxfbh.patch
maintainers-fix-drivers-ieee802154.patch
maintainers-remove-firmware-isci.patch
maintainers-remove-arch-x86-platform-mrst-pmu.patch
maintainers-fix-documentation-mei.patch
maintainers-remove-drivers-mmc-host-imxmmc.patch
maintainers-remove-arch-lib-perf_eventc.patch
maintainers-remove-include-linux-of_pwmh.patch
maintainers-fix-drivers-staging-sm7xx.patch
linux-next.patch

