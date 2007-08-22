From: akpm@linux-foundation.org
Subject: + maintainters-use-our-mail-list-as-blackfin-arch-maintainters.patch added to -mm tree
Date: Wed, 22 Aug 2007 15:53:42 -0700
Message-ID: <200708222253.l7MMrgI1008972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758570AbXHVWxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 18:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     MAINTAINTERS: use our mail list as Blackfin arch maintainters
has been added to the -mm tree.  Its filename is
     maintainters-use-our-mail-list-as-blackfin-arch-maintainters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINTERS: use our mail list as Blackfin arch maintainters
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   30 +-----------------------------
 1 files changed, 1 insertion(+), 29 deletions(-)

diff -puN MAINTAINERS~maintainters-use-our-mail-list-as-blackfin-arch-maintainters MAINTAINERS
--- a/MAINTAINERS~maintainters-use-our-mail-list-as-blackfin-arch-maintainters
+++ a/MAINTAINERS
@@ -717,35 +717,7 @@ M:	rpurdie@rpsys.net
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

cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
blackfin-enable-arbitary-speed-serial-setting.patch
kconfig-syntax-cleanups.patch
add-stack-checking-for-blackfin.patch
maintainters-use-our-mail-list-as-blackfin-arch-maintainters.patch
