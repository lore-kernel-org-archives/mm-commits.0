From: akpm@linux-foundation.org
Subject: + readme-fix-a-wrong-filename.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:30:40 -0800
Message-ID: <200902192030.n1JKUewp021019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbZBSUaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:30:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, sam@ravnborg.org


The patch titled
     README: fix a wrong filename
has been added to the -mm tree.  Its filename is
     readme-fix-a-wrong-filename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: README: fix a wrong filename
From: Li Zefan <lizf@cn.fujitsu.com>

It should be Documentation/build/kconfig.txt.

Introduced by commit 2af238e455ef5fd31c2f7a06c2db3f13d843b9bf
("kbuild: make *config usage docs").

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 README |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN README~readme-fix-a-wrong-filename README
--- a/README~readme-fix-a-wrong-filename
+++ a/README
@@ -188,7 +188,7 @@ CONFIGURING the kernel:
 			   values to random values.
 
    You can find more information on using the Linux kernel config tools
-   in Documentation/kbuild/make-configs.txt.
+   in Documentation/kbuild/kconfig.txt.
 
 	NOTES on "make config":
 	- having unnecessary drivers will make the kernel bigger, and can
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
readme-fix-a-wrong-filename.patch

