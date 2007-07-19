From: akpm@linux-foundation.org
Subject: - drivers-edac-update-maintainers-files-for-edac.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:44 -0700
Message-ID: <200707192007.l6JK7i21020363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757063AbXGSUPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: update MAINTAINERS files for EDAC
has been removed from the -mm tree.  Its filename was
     drivers-edac-update-maintainers-files-for-edac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: update MAINTAINERS files for EDAC
From: Douglas Thompson <dougthompson@xmission.com>

Added new maintainers for the new EDAC drivers.

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN MAINTAINERS~drivers-edac-update-maintainers-files-for-edac MAINTAINERS
--- a/MAINTAINERS~drivers-edac-update-maintainers-files-for-edac
+++ a/MAINTAINERS
@@ -1410,6 +1410,27 @@ L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 
+EDAC-I82443BXGX
+P:	Tim Small
+M:	tim@buttersideup.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
+EDAC-I3000
+P:	Jason Uhlenkott
+M:	juhlenko@akamai.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
+EDAC-I5000
+P:	Doug Thompson
+M:	norsk5@xmission.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
 EDAC-R82600
 P:	Tim Small
 M:	tim@buttersideup.com
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
