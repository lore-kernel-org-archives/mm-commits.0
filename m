From: akpm@linux-foundation.org
Subject: - typo-fro-from.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:32 -0700
Message-ID: <200707192002.l6JK2Wh4019682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034AbXGSUQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     Typo: fro -> from
has been removed from the -mm tree.  Its filename was
     typo-fro-from.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Typo: fro -> from
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/console/console.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/console/console.txt~typo-fro-from Documentation/console/console.txt
--- a/Documentation/console/console.txt~typo-fro-from
+++ a/Documentation/console/console.txt
@@ -29,7 +29,7 @@ In newer kernels, the following are also
 
 If sysfs is enabled, the contents of /sys/class/vtconsole can be
 examined. This shows the console backends currently registered by the
-system which are named vtcon<n> where <n> is an integer fro 0 to 15. Thus:
+system which are named vtcon<n> where <n> is an integer from 0 to 15. Thus:
 
        ls /sys/class/vtconsole
        .  ..  vtcon0  vtcon1
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

origin.patch
git-r8169.patch
