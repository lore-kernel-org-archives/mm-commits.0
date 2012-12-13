From: akpm@linux-foundation.org
Subject: + maintainers-adjust-for-uapi-firewire.patch added to -mm tree
Date: Thu, 13 Dec 2012 13:53:41 -0800
Message-ID: <20121213215341.F005D200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53769 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2LMVxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Dec 2012 16:53:44 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so2045wib.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2012 13:53:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de


The patch titled
     Subject: MAINTAINERS: adjust for UAPI: firewire
has been added to the -mm tree.  Its filename is
     maintainers-adjust-for-uapi-firewire.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3129,7 +3129,8 @@ W:	http://ieee1394.wiki.kernel.org/
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
linux-next.patch
maintainers-adjust-for-uapi-firewire.patch

