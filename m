From: akpm@linux-foundation.org
Subject: + ieee1394-update-maintainers-database.patch added to -mm tree
Date: Sat, 21 Apr 2007 19:53:18 -0700
Message-ID: <200704220253.l3M2rIq9018220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbXDVCxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 22:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de, ben.collins@ubuntu.com


The patch titled
     ieee1394: update MAINTAINERS database
has been added to the -mm tree.  Its filename is
     ieee1394-update-maintainers-database.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ieee1394-update-maintainers-database.patch
git-ieee1394.patch
