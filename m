From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-arch-arm-common-time-acornc.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:53 -0800
Message-ID: <20130107192554.1E56020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52566 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGTZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:56 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so1262015bkc.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove arch/arm/common/time-acorn.c
has been removed from the -mm tree.  Its filename was
     maintainers-remove-arch-arm-common-time-acornc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove arch/arm/common/time-acorn.c

This file was moved to arch/arm/mach-rpc/time.c by commit a1be5d6 ("ARM:
riscpc: move time-acorn.c to mach-rpc"), and the pattern for
arch/arm/mach-rpc/ already exists.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-arch-arm-common-time-acornc MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arch-arm-common-time-acornc
+++ a/MAINTAINERS
@@ -1068,7 +1068,6 @@ M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
-F:	arch/arm/common/time-acorn.c
 F:	arch/arm/include/asm/hardware/entry-macro-iomd.S
 F:	arch/arm/include/asm/hardware/ioc.h
 F:	arch/arm/include/asm/hardware/iomd.h
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

