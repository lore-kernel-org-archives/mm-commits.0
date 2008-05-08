From: akpm@linux-foundation.org
Subject: + cgroups-fix-documentation.patch added to -mm tree
Date: Thu, 08 May 2008 13:13:28 -0700
Message-ID: <200805082013.m48KDS6b003612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240AbYEHUWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:22:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhaval@linux.vnet.ibm.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, skumar@linux.vnet.ibm.com


The patch titled
     cgroups: fix documentation
has been added to the -mm tree.  Its filename is
     cgroups-fix-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix documentation
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Correct the cgroups documentation to reflect the correct file names.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups.txt~cgroups-fix-documentation Documentation/cgroups.txt
--- a/Documentation/cgroups.txt~cgroups-fix-documentation
+++ a/Documentation/cgroups.txt
@@ -310,8 +310,8 @@ and then start a subshell 'sh' in that c
   cd /dev/cgroup
   mkdir Charlie
   cd Charlie
-  /bin/echo 2-3 > cpus
-  /bin/echo 1 > mems
+  /bin/echo 2-3 > cpuset.cpus
+  /bin/echo 1 > cpuset.mems
   /bin/echo $$ > tasks
   sh
   # The subshell 'sh' is now running in cgroup Charlie
_

Patches currently in -mm which might be from dhaval@linux.vnet.ibm.com are

cgroups-fix-documentation.patch

