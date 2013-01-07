From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-drivers-platform-msm.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:50 -0800
Message-ID: <20130107192550.A1EDC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36481 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGTZv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:51 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so2115963qcq.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, bryanh@codeaurora.org, davidb@codeaurora.org, dwalker@fifo99.com, kheitke@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove drivers/platform/msm/
has been removed from the -mm tree.  Its filename was
     maintainers-remove-drivers-platform-msm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove drivers/platform/msm/

Added by commit 8a5700c ("add drivers/platform/msm to MSM subsystem") in
2011, but I could not find any trace of that directory being ever added to
the repository.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Kenneth Heitke <kheitke@codeaurora.org>
Acked-by: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-drivers-platform-msm MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-drivers-platform-msm
+++ a/MAINTAINERS
@@ -1005,7 +1005,6 @@ F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
-F:	drivers/platform/msm/
 F:	drivers/*/pm8???-*
 F:	include/linux/mfd/pm8xxx/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

