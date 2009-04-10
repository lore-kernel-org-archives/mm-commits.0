From: akpm@linux-foundation.org
Subject: + doc-use-correct-debugfs-mountpoint.patch added to -mm tree
Date: Fri, 10 Apr 2009 15:31:35 -0700
Message-ID: <200904102231.n3AMVZJL025148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZDJWdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 18:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shen@cn.fujitsu.com, balagi@justmail.de


The patch titled
     doc: use correct debugfs mountpoint
has been added to the -mm tree.  Its filename is
     doc-use-correct-debugfs-mountpoint.patch

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
Subject: doc: use correct debugfs mountpoint
From: Shen Feng <shen@cn.fujitsu.com>

Use the default mountpoint of debugfs in the pktcdvd ABI.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Cc: <balagi@justmail.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/debugfs-pktcdvd |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/ABI/testing/debugfs-pktcdvd~doc-use-correct-debugfs-mountpoint Documentation/ABI/testing/debugfs-pktcdvd
--- a/Documentation/ABI/testing/debugfs-pktcdvd~doc-use-correct-debugfs-mountpoint
+++ a/Documentation/ABI/testing/debugfs-pktcdvd
@@ -1,4 +1,4 @@
-What:           /debug/pktcdvd/pktcdvd[0-7]
+What:           /sys/kernel/debug/pktcdvd/pktcdvd[0-7]
 Date:           Oct. 2006
 KernelVersion:  2.6.20
 Contact:        Thomas Maier <balagi@justmail.de>
@@ -10,10 +10,10 @@ debugfs interface
 The pktcdvd module (packet writing driver) creates
 these files in debugfs:
 
-/debug/pktcdvd/pktcdvd[0-7]/
+/sys/kernel/debug/pktcdvd/pktcdvd[0-7]/
     info            (0444) Lots of driver statistics and infos.
 
 Example:
 -------
 
-cat /debug/pktcdvd/pktcdvd0/info
+cat /sys/kernel/debug/pktcdvd/pktcdvd0/info
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

doc-use-correct-debugfs-mountpoint.patch

