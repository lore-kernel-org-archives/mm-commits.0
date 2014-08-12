From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-metag-imgdafs-pattern.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:43:21 -0700
Message-ID: <53ea6e59.zyUD7bjhwxtxyilZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:40312 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaHLTnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:21 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2668460pab.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, james.hogan@imgtec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove METAG imgdafs pattern
has been removed from the -mm tree.  Its filename was
     maintainers-remove-metag-imgdafs-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove METAG imgdafs pattern

This never made it into the kernel tree.  Remove it.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-metag-imgdafs-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-metag-imgdafs-pattern
+++ a/MAINTAINERS
@@ -5867,7 +5867,6 @@ F:	drivers/clocksource/metag_generic.c
 F:	drivers/irqchip/irq-metag.c
 F:	drivers/irqchip/irq-metag-ext.c
 F:	drivers/tty/metag_da.c
-F:	fs/imgdafs/
 
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

