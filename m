From: akpm@linux-foundation.org
Subject: [merged] doc-use-correct-debugfs-mountpoint.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:11 -0700
Message-ID: <200904141950.n3EJoBFR020007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbZDNTwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shen@cn.fujitsu.com, balagi@justmail.de, mm-commits@vger.kernel.org


The patch titled
     doc: use correct debugfs mountpoint
has been removed from the -mm tree.  Its filename was
     doc-use-correct-debugfs-mountpoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

