From: akpm@linux-foundation.org
Subject: + documentation-sysctl-nettxt-fix-a-typo.patch added to -mm tree
Date: Thu, 09 Apr 2009 12:42:05 -0700
Message-ID: <200904091942.n39Jg5E0022300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755855AbZDIToP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 15:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, davem@davemloft.net


The patch titled
     Documentation/sysctl/net.txt: fix a typo
has been added to the -mm tree.  Its filename is
     documentation-sysctl-nettxt-fix-a-typo.patch

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

documentation-sysctl-nettxt-fix-a-typo.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch

