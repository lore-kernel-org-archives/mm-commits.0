From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-clk-sirf-patterns.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:43:09 -0700
Message-ID: <53ea6e4d.MZIKr3hTDydY63Xb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:56481 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaHLTnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:10 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2669667pde.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, Baohua.Song@csr.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update clk/sirf patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-clk-sirf-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update clk/sirf patterns

Commit 7bf21bc81f28 ("clk: sirf: re-arch to make the codes support
both prima2 and atlas6") moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-clk-sirf-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-clk-sirf-patterns
+++ a/MAINTAINERS
@@ -911,7 +911,7 @@ L:	linux-arm-kernel@lists.infradead.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git
 S:	Maintained
 F:	arch/arm/mach-prima2/
-F:	drivers/clk/clk-prima2.c
+F:	drivers/clk/sirf/
 F:	drivers/clocksource/timer-prima2.c
 F:	drivers/clocksource/timer-marco.c
 N:	[^a-z]sirf
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

