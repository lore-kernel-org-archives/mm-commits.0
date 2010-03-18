From: akpm@linux-foundation.org
Subject: + memcg-fix-typo-in-memcg-documentation.patch added to -mm tree
Date: Thu, 18 Mar 2010 15:35:24 -0700
Message-ID: <201003182235.o2IMZOum019734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204Ab0CRWf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 18:35:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com


The patch titled
     memcg: fix typo in memcg documentation
has been added to the -mm tree.  Its filename is
     memcg-fix-typo-in-memcg-documentation.patch

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
Subject: memcg: fix typo in memcg documentation
From: Greg Thelen <gthelen@google.com>

Update memory.txt to be more consistent: s/swapiness/swappiness/

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memcg-fix-typo-in-memcg-documentation Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-fix-typo-in-memcg-documentation
+++ a/Documentation/cgroups/memory.txt
@@ -340,7 +340,7 @@ Note:
 5.3 swappiness
   Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
 
-  Following cgroups' swapiness can't be changed.
+  Following cgroups' swappiness can't be changed.
   - root cgroup (uses /proc/sys/vm/swappiness).
   - a cgroup which uses hierarchy and it has child cgroup.
   - a cgroup which uses hierarchy and not the root of hierarchy.
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-fix-typo-in-memcg-documentation.patch
linux-next.patch
sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch

