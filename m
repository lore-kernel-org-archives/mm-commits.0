From: akpm@linux-foundation.org
Subject: - maintainters-use-our-mail-list-as-blackfin-arch-maintainters.patch removed from -mm tree
Date: Fri, 12 Oct 2007 15:25:41 -0700
Message-ID: <200710122225.l9CMPfxX006567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932996AbXJLWZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Oct 2007 18:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINTERS: use our mail list as Blackfin arch maintainters
has been removed from the -mm tree.  Its filename was
     maintainters-use-our-mail-list-as-blackfin-arch-maintainters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINTERS: use our mail list as Blackfin arch maintainters
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff -puN MAINTAINERS~maintainters-use-our-mail-list-as-blackfin-arch-maintainters MAINTAINERS
--- a/MAINTAINERS~maintainters-use-our-mail-list-as-blackfin-arch-maintainters
+++ a/MAINTAINERS
@@ -749,35 +749,7 @@ M:	rpurdie@rpsys.net
 S:	Maintained
 
 BLACKFIN ARCHITECTURE
-P:	Aubrey Li
-M:	aubrey.li@analog.com
-P:	Bernd Schmidt
-M:	bernd.schmidt@analog.com
-P:	Bryan Wu
-M:	bryan.wu@analog.com
-P:	Grace Pan
-M:	grace.pan@analog.com
-P:	Marc Hoffman
-M:	marc.hoffman@analog.com
-P:	Michael Hennerich
-M:	michael.hennerich@analog.com
-P:	Mike Frysinger
-M:	michael.frysinger@analog.com
-P:	Jerry Zeng
-M:	jerry.zeng@analog.com
-P:	Jie Zhang
-M:	jie.zhang@analog.com
-P:	Robin Getz
-M:	robin.getz@analog.com
-P:	Roy Huang
-M:	roy.huang@analog.com
-P:	Sonic Zhang
-M:	sonic.zhang@analog.com
-P:	Vivi Li
-M:	vivi.li@analog.com
-P:	Yi Li
-M:	yi.li@analog.com
-L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-cpufreq.patch
git-kbuild.patch
blackfin-on-chip-nand-flash-controller-driver.patch
add-stack-checking-for-blackfin.patch
kernel-printkc-concerns-about-the-console-handover.patch
bf54x-lq043fb-framebuffer-driver-for-blackfin-bf54x-framebuffer-device-driver.patch
bitops-introduce-lock-ops.patch
replace-__attribute_pure__-with-__pure.patch
