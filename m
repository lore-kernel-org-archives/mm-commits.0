From: akpm@linux-foundation.org
Subject: [merged] readme-fix-a-wrong-filename.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:37 -0800
Message-ID: <200902232006.n1NK6bOD013407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbZBWUHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:07:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     README: fix a wrong filename
has been removed from the -mm tree.  Its filename was
     readme-fix-a-wrong-filename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

