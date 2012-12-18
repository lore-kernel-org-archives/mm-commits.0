From: akpm@linux-foundation.org
Subject: [merged] maintainers-adjust-for-uapi-firewire.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:45 -0800
Message-ID: <20121218200346.20B5A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64807 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:48 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so63125bkc.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: adjust for UAPI: firewire
has been removed from the -mm tree.  Its filename was
     maintainers-adjust-for-uapi-firewire.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: MAINTAINERS: adjust for UAPI: firewire

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-adjust-for-uapi-firewire MAINTAINERS
--- a/MAINTAINERS~maintainers-adjust-for-uapi-firewire
+++ a/MAINTAINERS
@@ -3128,7 +3128,8 @@ W:	http://ieee1394.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
 S:	Maintained
 F:	drivers/firewire/
-F:	include/linux/firewire*.h
+F:	include/linux/firewire.h
+F:	include/uapi/linux/firewire*.h
 F:	tools/firewire/
 
 FIRMWARE LOADER (request_firmware)
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

origin.patch

