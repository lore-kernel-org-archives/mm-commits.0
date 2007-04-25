From: akpm@linux-foundation.org
Subject: - ieee1394-update-maintainers-database.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:38:49 -0700
Message-ID: <200704252038.l3PKcn9g012255@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993184AbXDYU6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefanr@s5r6.in-berlin.de, ben.collins@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     ieee1394: update MAINTAINERS database
has been removed from the -mm tree.  Its filename was
     ieee1394-update-maintainers-database.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ieee1394: update MAINTAINERS database
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

  - update Ben's address
  - replace Ben's contact by mine as raw1394's 2nd contact
  - eth1394's and pcilynx's maintenance doesn't really differ from that
    of other parts of the stack like video1394

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Ben Collins <ben.collins@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff -puN MAINTAINERS~ieee1394-update-maintainers-database MAINTAINERS
--- a/MAINTAINERS~ieee1394-update-maintainers-database
+++ a/MAINTAINERS
@@ -1690,7 +1690,7 @@ S:	Maintained
 
 IEEE 1394 SUBSYSTEM
 P:	Ben Collins
-M:	bcollins@debian.org
+M:	ben.collins@ubuntu.com
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
@@ -1698,25 +1698,11 @@ W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 
-IEEE 1394 IPV4 DRIVER (eth1394)
-P:	Stefan Richter
-M:	stefanr@s5r6.in-berlin.de
-L:	linux1394-devel@lists.sourceforge.net
-S:	Odd Fixes
-
-IEEE 1394 PCILYNX DRIVER
-P:	Jody McIntyre
-M:	scjody@modernduck.com
-P:	Stefan Richter
-M:	stefanr@s5r6.in-berlin.de
-L:	linux1394-devel@lists.sourceforge.net
-S:	Odd Fixes
-
-IEEE 1394 RAW I/O DRIVER
-P:	Ben Collins
-M:	bcollins@debian.org
+IEEE 1394 RAW I/O DRIVER (raw1394)
 P:	Dan Dennedy
 M:	dan@dennedy.org
+P:	Stefan Richter
+M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

origin.patch
git-ieee1394.patch
sbp2-include-fixes.patch
