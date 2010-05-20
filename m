From: akpm@linux-foundation.org
Subject: + documentation-cgroups-cgroupstxt-fix-reference-to-numtasks.patch added to -mm tree
Date: Thu, 20 May 2010 13:21:16 -0700
Message-ID: <201005202021.o4KKLGmu002625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176Ab0ETUVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 16:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: twoerner@gmail.com, menage@google.com


The patch titled
     Documentation/cgroups/cgroups.txt: fix reference to "numtasks"
has been added to the -mm tree.  Its filename is
     documentation-cgroups-cgroupstxt-fix-reference-to-numtasks.patch

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
Subject: Documentation/cgroups/cgroups.txt: fix reference to "numtasks"
From: Trevor Woerner <twoerner@gmail.com>

Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cgroups/cgroups.txt~documentation-cgroups-cgroupstxt-fix-reference-to-numtasks Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~documentation-cgroups-cgroupstxt-fix-reference-to-numtasks
+++ a/Documentation/cgroups/cgroups.txt
@@ -339,7 +339,7 @@ To mount a cgroup hierarchy with all ava
 The "xxx" is not interpreted by the cgroup code, but will appear in
 /proc/mounts so may be any useful identifying string that you like.
 
-To mount a cgroup hierarchy with just the cpuset and numtasks
+To mount a cgroup hierarchy with just the cpuset and memory
 subsystems, type:
 # mount -t cgroup -o cpuset,memory hier1 /dev/cgroup
 
_

Patches currently in -mm which might be from twoerner@gmail.com are

documentation-cgroups-cgroupstxt-fix-reference-to-numtasks.patch

