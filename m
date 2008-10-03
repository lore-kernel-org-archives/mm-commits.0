From: akpm@linux-foundation.org
Subject: + cpusets-remove-pj-from-cpuset-maintainers.patch added to -mm tree
Date: Thu, 02 Oct 2008 18:17:43 -0700
Message-ID: <200810030117.m931HhNU003947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbYJCBRv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 21:17:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, dfults@sgi.com, jh@sgi.com, menage@google.com, pj@usa.net


The patch titled
     cpusets: remove pj from cpuset maintainers
has been added to the -mm tree.  Its filename is
     cpusets-remove-pj-from-cpuset-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: remove pj from cpuset maintainers
From: Paul Jackson <pj@sgi.com>

Remove myself from the kernel MAINTAINERS file for cpusets.  I am leaving
SGI and probably will not be active in Linux kernel work.  I can be
reached at <pj@usa.net>.  Contact Derek Fults <dfults@sgi.com> for future
SGI+cpuset related issues.  I'm off to the next chapter of this good life.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Cc: John Hesterberg <jh@sgi.com>
Cc: Paul Jackson <pj@usa.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

diff -puN MAINTAINERS~cpusets-remove-pj-from-cpuset-maintainers MAINTAINERS
--- a/MAINTAINERS~cpusets-remove-pj-from-cpuset-maintainers
+++ a/MAINTAINERS
@@ -1228,9 +1228,7 @@ M:	hpa@zytor.com
 S:	Maintained
 
 CPUSETS
-P:	Paul Jackson
 P:	Paul Menage
-M:	pj@sgi.com
 M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
_

Patches currently in -mm which might be from pj@sgi.com are

cpusets-remove-pj-from-cpuset-maintainers.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
cpusetc-remove-extra-variable.patch

