From: akpm@linux-foundation.org
Subject: [merged] aoe-update-aoe-maintainer-information.patch removed from -mm tree
Date: Fri, 27 Mar 2015 11:16:37 -0700
Message-ID: <55159e85.h8VMpJ7VsNdPUXz6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbbC0SQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ed.cashin@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update aoe maintainer information
has been removed from the -mm tree.  Its filename was
     aoe-update-aoe-maintainer-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ed.cashin@acm.org>
Subject: aoe: update aoe maintainer information

The coraid.com email address is defunct.  The old aoe support area hosted
at coraid.com is no longer up.  These changes update the email and website
to current ones.

Signed-off-by: Ed Cashin <ed.cashin@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~aoe-update-aoe-maintainer-information MAINTAINERS
--- a/MAINTAINERS~aoe-update-aoe-maintainer-information
+++ a/MAINTAINERS
@@ -1675,8 +1675,8 @@ F:	drivers/misc/eeprom/at24.c
 F:	include/linux/platform_data/at24.h
 
 ATA OVER ETHERNET (AOE) DRIVER
-M:	"Ed L. Cashin" <ecashin@coraid.com>
-W:	http://support.coraid.com/support/linux
+M:	"Ed L. Cashin" <ed.cashin@acm.org>
+W:	http://www.openaoe.org/
 S:	Supported
 F:	Documentation/aoe/
 F:	drivers/block/aoe/
_

Patches currently in -mm which might be from ed.cashin@acm.org are

origin.patch

