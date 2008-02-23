From: akpm@linux-foundation.org
Subject: + cpuset-trivial-documentation-fix-s-n_memory-n_high_memory.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:28:06 -0800
Message-ID: <200802230728.m1N7SxjP017880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbYBWH3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:29:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, clameter@sgi.com, menage@google.com, pj@sgi.com


The patch titled
     cpuset: trivial documentation fix s/N_MEMORY/N_HIGH_MEMORY/
has been added to the -mm tree.  Its filename is
     cpuset-trivial-documentation-fix-s-n_memory-n_high_memory.patch

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
Subject: cpuset: trivial documentation fix s/N_MEMORY/N_HIGH_MEMORY/
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Current implementation of cpuset track N_HIGH_MEMORY instead N_MEMORY. 
(N_MEMORY doesn't exist in current implementation)

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cpusets.txt~cpuset-trivial-documentation-fix-s-n_memory-n_high_memory Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpuset-trivial-documentation-fix-s-n_memory-n_high_memory
+++ a/Documentation/cpusets.txt
@@ -209,7 +209,7 @@ and name space for cpusets, with a minim
 The cpus and mems files in the root (top_cpuset) cpuset are
 read-only.  The cpus file automatically tracks the value of
 cpu_online_map using a CPU hotplug notifier, and the mems file
-automatically tracks the value of node_states[N_MEMORY]--i.e.,
+automatically tracks the value of node_states[N_HIGH_MEMORY]--i.e.,
 nodes with memory--using the cpuset_track_online_nodes() hook.
 
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

cpuset-trivial-documentation-fix-s-n_memory-n_high_memory.patch
