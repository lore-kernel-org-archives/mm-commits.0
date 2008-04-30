From: akpm@linux-foundation.org
Subject: + cpusets-update-maintainers.patch added to -mm tree
Date: Wed, 30 Apr 2008 01:17:20 -0700
Message-ID: <200804300817.m3U8HKvd004260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754967AbYD3ISQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 04:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, menage@google.com, mingo@elte.hu, simon.derr@bull.net


The patch titled
     cpusets: update maintainers
has been added to the -mm tree.  Its filename is
     cpusets-update-maintainers.patch

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
Subject: cpusets: update maintainers
From: Paul Jackson <pj@sgi.com>

Update CPUSETS MAINTAINERS to reflect the more active role of Paul Menage
(secondary to his work on cgroups) and the retirement of the original author
of cpusets, Simon Derr.  Thanks, Simon!  Best of luck to you.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: Simon Derr <simon.derr@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~cpusets-update-maintainers MAINTAINERS
--- a/MAINTAINERS~cpusets-update-maintainers
+++ a/MAINTAINERS
@@ -1201,9 +1201,9 @@ S:	Maintained
 
 CPUSETS
 P:	Paul Jackson
-P:	Simon Derr
+P:	Paul Menage
 M:	pj@sgi.com
-M:	simon.derr@bull.net
+M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 S:	Supported
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
cpusets-update-maintainers.patch
git-sched.patch

