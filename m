From: akpm@linux-foundation.org
Subject: [merged] documentation-sysctl-nettxt-fix-a-typo.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:29 -0700
Message-ID: <200904141948.n3EJmTNZ019063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbZDNTud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Documentation/sysctl/net.txt: fix a typo
has been removed from the -mm tree.  Its filename was
     documentation-sysctl-nettxt-fix-a-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/sysctl/net.txt: fix a typo
From: Li Zefan <lizf@cn.fujitsu.com>

s/spicified/specified

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/net.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/net.txt~documentation-sysctl-nettxt-fix-a-typo Documentation/sysctl/net.txt
--- a/Documentation/sysctl/net.txt~documentation-sysctl-nettxt-fix-a-typo
+++ a/Documentation/sysctl/net.txt
@@ -95,7 +95,7 @@ of struct cmsghdr structures with append
 
 There is only one file in this directory.
 unix_dgram_qlen limits the max number of datagrams queued in Unix domain
-socket's buffer. It will not take effect unless PF_UNIX flag is spicified.
+socket's buffer. It will not take effect unless PF_UNIX flag is specified.
 
 
 3. /proc/sys/net/ipv4 - IPV4 settings
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
btrfs-use-memdup_user.patch
sysfs-use-memdup_user.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
xattr-use-memdup_user.patch
xfs-use-memdup_user.patch
ncpfs-use-memdup_user.patch
ecryptfs-use-memdup_user.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch

