From: akpm@linux-foundation.org
Subject: + typo-fro-from.patch added to -mm tree
Date: Wed, 18 Jul 2007 15:51:05 -0700
Message-ID: <200707182251.l6IMp5l6000692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbXGRWvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 18:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de


The patch titled
     Typo: fro -> from
has been added to the -mm tree.  Its filename is
     typo-fro-from.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Typo: fro -> from
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/console/console.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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
typo-fro-from.patch
git-r8169.patch
