From: akpm@linux-foundation.org
Subject: + aoe-update-aoe-maintainer-information.patch added to -mm tree
Date: Tue, 17 Mar 2015 15:32:46 -0700
Message-ID: <5508ab8e.UpeWVfp3lMD8uOTh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbbCQWcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Mar 2015 18:32:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ed.cashin@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update aoe maintainer information
has been added to the -mm tree.  Its filename is
     aoe-update-aoe-maintainer-information.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-update-aoe-maintainer-information.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-update-aoe-maintainer-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

aoe-update-aoe-maintainer-information.patch

